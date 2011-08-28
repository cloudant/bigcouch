#!/usr/bin/env escript
%% -*- erlang -*-
%%! -pa ./src/couchdb -sasl errlog_type error -boot start_sasl -noshell

% Licensed under the Apache License, Version 2.0 (the "License"); you may not
% use this file except in compliance with the License. You may obtain a copy of
% the License at
%
%   http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
% WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
% License for the specific language governing permissions and limitations under
% the License.


path(FileName) ->
    test_util:build_file(FileName).


main(_) ->
    test_util:init_code_path(),
    couch_config:start_link([]),
    etap:plan(length(counts()) * 2),
    case (catch test()) of
        ok ->
            etap:end_tests();
        Other ->
            etap:diag(io_lib:format("Test died abnormally:~n~p", [Other])),
            timer:sleep(333),
            etap:bail()
    end,
    ok.


test() ->
    lists:foreach(fun(C) -> test_copy(C) end, counts()),
    ok.


counts() ->
    [
           10,    20,     50,    100,    300,    500,
          700,   811,   2333,   6666,   9999,  15003,
        21477, 38888,  66069, 150123, 420789, 711321
    ].


reduce_fun() ->
    fun
        (reduce, KVs) -> length(KVs);
        (rereduce, Reds) -> lists:sum(Reds)
    end.


test_copy(NumItems) ->
    {ok, SrcBt0} = open_btree("./apps/couch/test/etap/temp.022.1"),
    {ok, SrcBt} = load_btree(SrcBt0, NumItems),
    Opts = [create, overwrite],
    {ok, Fd} = couch_file:open(path("./apps/couch/test/etap/temp.022.2"), Opts),
    {ok, DstBt} = couch_btree:copy(SrcBt, Fd),
    check_same(SrcBt, DstBt).


open_btree(Filename) ->
    {ok, Fd} = couch_file:open(path(Filename), [create, overwrite]),
    couch_btree:open(nil, Fd, [{reduce, reduce_fun()}]).


load_btree(Bt, N) when N < 1000 ->
    KVs = [{I, I} || I <- lists:seq(1, N)],
    couch_btree:add(Bt, KVs);
load_btree(Bt, N) ->
    C = N - 1000,
    KVs = [{I+C, I+C} || I <- lists:seq(1, 100)],
    {ok, Bt1} = couch_btree:add(Bt, KVs),
    load_btree(Bt1, C).


check_same(Src, Dst) ->
    {_, SrcRed} = couch_btree:get_state(Src),
    {_, DstRed} = couch_btree:get_state(Dst),
    etap:is(DstRed, SrcRed, "Same reduction value in copied btree."),
    {ok, _, SrcKVs} = couch_btree:foldl(Src, fun(KV, A) -> {ok,[KV|A]} end, []),
    {ok, _, DstKVs} = couch_btree:foldl(Dst, fun(KV, A) -> {ok,[KV|A]} end, []),
    etap:is(SrcKVs, DstKVs, "Same key value pairs in copied btree.").


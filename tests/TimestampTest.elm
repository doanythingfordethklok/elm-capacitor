module TimestampTest exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Random
import Test exposing (Test, describe, fuzz, test)
import Time exposing (Posix, millisToPosix, posixToMillis)
import Utils.Timestamp as Timestamp exposing (dateString, timeString)


testDate : Posix
testDate =
    millisToPosix 1546408919456


second : Int
second =
    1000


minute : Int
minute =
    second * 60


hour : Int
hour =
    minute * 60


day : Int
day =
    hour * 24


suite : Test
suite =
    describe "Timestamp"
        [ describe "Absolute Formatters"
            [ test "timeString simple" <|
                \_ ->
                    timeString Time.utc testDate
                        |> Expect.equal "6:01:59 AM"
            , test "dateString simple" <|
                \_ ->
                    dateString Time.utc testDate
                        |> Expect.equal "Jan 2, 2019"
            ]
        , describe "Relative Formatters"
            [ fuzz (Fuzz.intRange 0 59) "just now" <|
                \n ->
                    let
                        dtNow =
                            posixToMillis testDate
                                + (n * second)
                                |> millisToPosix
                    in
                    Timestamp.format Time.utc dtNow testDate
                        |> Expect.equal "just now"
            , fuzz (Fuzz.intRange 0 59) "over an hour, under 2 hours ago" <|
                \n ->
                    let
                        dtNow =
                            posixToMillis testDate
                                + hour
                                + (n * minute)
                                |> millisToPosix
                    in
                    Timestamp.format Time.utc dtNow testDate
                        |> Expect.equal "an hour ago"
            , fuzz (Fuzz.intRange 2 23) "hours ago, less than a day" <|
                \n ->
                    let
                        dtNow =
                            posixToMillis testDate
                                + (n * hour)
                                |> millisToPosix
                    in
                    Timestamp.format Time.utc dtNow testDate
                        |> String.right 9
                        |> Expect.equal "hours ago"
            , fuzz (Fuzz.intRange 0 23) "a day ago" <|
                \n ->
                    let
                        dtNow =
                            posixToMillis testDate
                                + day
                                + (n * hour)
                                |> millisToPosix
                    in
                    Timestamp.format Time.utc dtNow testDate
                        |> Expect.equal "a day ago"
            , fuzz (Fuzz.intRange 2 4) "days ago" <|
                \n ->
                    let
                        dtNow =
                            posixToMillis testDate
                                + (n * day)
                                |> millisToPosix
                    in
                    Timestamp.format Time.utc dtNow testDate
                        |> String.right 8
                        |> Expect.equal "days ago"
            , fuzz (Fuzz.intRange (5 * day) Random.maxInt) "date is more 5 days or more in the past" <|
                \n ->
                    let
                        dtNow =
                            posixToMillis testDate
                                + n
                                |> millisToPosix
                    in
                    Timestamp.format Time.utc dtNow testDate
                        |> Expect.equal "Jan 2, 2019 6:01:59 AM"
            , fuzz (Fuzz.intRange 1 Random.maxInt) "date is in the future" <|
                \n ->
                    let
                        dtNow =
                            posixToMillis testDate
                                - n
                                |> millisToPosix
                    in
                    Timestamp.format Time.utc dtNow testDate
                        |> Expect.equal "Jan 2, 2019 6:01:59 AM"
            ]
        ]

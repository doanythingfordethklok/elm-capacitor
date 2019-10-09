module Utils.Timestamp exposing (dateString, format, timeString)

{-| Time formatting module


# Formatters

@docs dateString, format, timeString

-}

import Time
    exposing
        ( Month(..)
        , Posix
        , Zone
        , millisToPosix
        , posixToMillis
        , toDay
        , toHour
        , toMinute
        , toMonth
        , toSecond
        , toYear
        )


toMonthString : Month -> String
toMonthString month =
    case month of
        Jan ->
            "Jan"

        Feb ->
            "Feb"

        Mar ->
            "Mar"

        Apr ->
            "Apr"

        May ->
            "May"

        Jun ->
            "Jun"

        Jul ->
            "Jul"

        Aug ->
            "Aug"

        Sep ->
            "Sep"

        Oct ->
            "Oct"

        Nov ->
            "Nov"

        Dec ->
            "Dec"


second : Int
second =
    1000


minute : Int
minute =
    60 * second


hour : Int
hour =
    60 * minute


day : Int
day =
    24 * hour


meridiem : Int -> String
meridiem h =
    if h < 12 then
        "AM"

    else
        "PM"


meridiemHour : Int -> String
meridiemHour h =
    if h == 0 then
        "12"

    else if h > 12 then
        h - 12 |> String.fromInt

    else
        String.fromInt h


{-| Given a time (Posix) and a time zone, format the date portion like MMM dd,yyyy
-}
dateString : Zone -> Posix -> String
dateString timezone dt =
    String.concat
        [ toMonth timezone dt |> toMonthString
        , " "
        , toDay timezone dt |> String.fromInt
        , ", "
        , toYear timezone dt |> String.fromInt
        ]


{-| Given a time (Posix) and a time zone, format the time portion like hh:mm:ss am/pm
-}
timeString : Zone -> Posix -> String
timeString timezone dt =
    String.concat
        [ toHour timezone dt |> meridiemHour
        , ":"
        , toMinute timezone dt |> String.fromInt |> String.padLeft 2 '0'
        , ":"
        , toSecond timezone dt |> String.fromInt |> String.padLeft 2 '0'
        , " "
        , toHour timezone dt |> meridiem
        ]


{-| Given a time (Posix), the time for now, and a time zone, format the difference between times. The intention is to use
this to perform custom formatting of creation times vs now. Emits strings like "just now", "8 minutes ago", etc.
-}
format : Zone -> Posix -> Posix -> String
format timezone dtNow dt =
    let
        millis_ago =
            posixToMillis dtNow - posixToMillis dt

        minutes_ago =
            millis_ago // minute

        hours_ago =
            millis_ago // hour

        days_ago =
            millis_ago // day
    in
    if millis_ago >= 0 then
        if minutes_ago < 1 then
            "just now"

        else if hours_ago == 0 then
            String.fromInt minutes_ago ++ " minutes ago"

        else if hours_ago == 1 then
            "an hour ago"

        else if days_ago == 0 then
            String.fromInt hours_ago ++ " hours ago"

        else if days_ago == 1 then
            "a day ago"

        else if days_ago < 5 then
            String.fromInt days_ago ++ " days ago"

        else
            String.join " " [ dateString timezone dt, timeString timezone dt ]

    else
        String.join " " [ dateString timezone dt, timeString timezone dt ]

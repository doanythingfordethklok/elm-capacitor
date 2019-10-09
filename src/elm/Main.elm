module Main exposing (main)

import Browser exposing (element)
import Html exposing (Html, button, div, h2, p, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Task
import Time exposing (Posix, Zone, ZoneName(..), millisToPosix)
import Utils.Timestamp as Timestamp


type alias Model =
    { full_name : String
    , time_zone : Zone
    , time_zone_name : ZoneName
    , current_time : Posix
    }


type Msg
    = SetCurrentTime Posix
    | SetTimeZone Zone
    | SetTimeZoneName ZoneName
    | UpdateTime


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetCurrentTime t ->
            ( { model | current_time = t }, Cmd.none )

        SetTimeZone z ->
            ( { model | time_zone = z }, Cmd.none )

        SetTimeZoneName n ->
            ( { model | time_zone_name = n }, Cmd.none )

        UpdateTime ->
            ( model, Task.perform SetCurrentTime Time.now )


view : Model -> Html Msg
view { full_name, current_time, time_zone, time_zone_name } =
    div []
        [ h2 [] [ text <| "Hello " ++ full_name ++ "!" ]
        , p []
            [ String.concat
                [ "The current time is "
                , Timestamp.timeString time_zone current_time
                , " and your timezone is "
                , case time_zone_name of
                    Name str ->
                        str ++ "."

                    Offset mins ->
                        String.fromInt mins ++ " minutes from UTC."
                ]
                |> text
            ]
        , button
            [ onClick UpdateTime
            , style "color" "#FF0266"
            , style "padding" "16px"
            , style "font-size" "24px"
            ]
            [ text "Refresh the time" ]
        ]


initialModel : Model
initialModel =
    Model
        "World"
        Time.utc
        (Name "")
        (millisToPosix 0)


init : {} -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.batch
        [ Task.perform SetCurrentTime Time.now
        , Task.perform SetTimeZone Time.here
        , Task.perform SetTimeZoneName Time.getZoneName
        ]
    )


main : Program {} Model Msg
main =
    element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }

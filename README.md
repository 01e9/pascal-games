# Pascal Games

Created by Oleg Artenii in high school.

Thanks to my teacher Brodicico Valeriu!

## How to Play

* Install [DOSBox](https://www.google.com/search?q=dosbox+download)

    ```sh
    sudo apt install dosbox
    ```

* Install [Turbo Pascal 7.0](https://mega.nz/#!wotThTaZ!vZhfOvJImK_tdK1h36uv7qpN6-CbpXOoOd9fcri6ZN4)

* Open DOSBox

    ```sh
    dosbox pascal-games/
    ```

    **OR** click on any game `.EXE`

* **RÎMA** (Snake)

    ![Screenshot](RIMA/screenshot.png)

    ```
    cd RIMA
    RIMA.EXE
    ```

    * To see the "Game Over" screen

        Rename `RIMA\TOP.IN.game-over` to `RIMA\TOP.IN`

* **TANK**

    ![Screenshot](TANK/screenshot.png)

    ```
    cd TANK
    TANK.EXE
    ```

* **TETRIS**

    ![Screenshot](TETRIS/screenshot.png)

    ```
    cd TETRIS
    TETRIS.EXE
    ```

## Fix slow moving

To increase DOSBox speed press CTRL-F12 _(CTRL-F11 to decrease)_.

## Compile

```
cd GAME_NAME
...\TP\BIN\TPC.EXE GAME_NAME.PAS
```

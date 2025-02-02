#pragma once

#include <iostream>
#include <cstdarg>
#include <string>
#include <print>

#ifdef _WIN32
#include <Windows.h>
#endif

class Log
{
    enum class Color
    {
        Cyan,
        Green,
        Yellow,
        Red,
        White,
    };

public:
    template<typename...Args>
    static void info(std::format_string<Args...> const & fmt, Args&&...args)
    {
        setConsoleColor(Color::Cyan);
        std::print(stdout, "[INFO]  ");
        setConsoleColor(Color::White);

        std::println(stdout, fmt, std::forward<Args>(args)...);
    }

    template<typename...Args>
    static void debug(std::format_string<Args...> const & fmt, Args&&...args)
    {
        setConsoleColor(Color::Green);
        std::print(stdout, "[DEBUG] ");
        setConsoleColor(Color::White);

        std::println(stdout, fmt, std::forward<Args>(args)...);
    }

    template<typename...Args>
    static void warn(std::format_string<Args...> const & fmt, Args&&...args)
    {
        setConsoleColor(Color::Yellow);
        std::print(stdout, "[WARN]  ");
        setConsoleColor(Color::White);

        std::println(stdout, fmt, std::forward<Args>(args)...);
    }

    template<typename...Args>
    static void error(std::format_string<Args...> const & fmt, Args&&...args)
    {
        setConsoleColor(Color::Red, stderr);
        std::print(stderr, "[ERROR] ");
        setConsoleColor(Color::White, stderr);

        std::println(stderr, fmt, std::forward<Args>(args)...);
    }

private:
    Log() = default;
    Log(Log const &) = delete;
    Log & operator=(Log const &) = delete;
    Log(Log &&) = delete;
    Log & operator=(Log &&) = delete;

    static void setConsoleColor(Color color, std::FILE * out = stdout)
    {
    #ifdef _WIN32
        HANDLE hConsole;
        if (out == stdin) {
            hConsole = GetStdHandle(STD_INPUT_HANDLE);
        }
        else if (out == stderr) {
            hConsole = GetStdHandle(STD_ERROR_HANDLE);
        }
        else {
            hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
        }

        switch (color) {
        case Color::White:
            SetConsoleTextAttribute(hConsole, WHITE_WIN_COLOR_CODE);
            break;
        case Color::Cyan:
            SetConsoleTextAttribute(hConsole, CYAN_WIN_COLOR_CODE);
            break;
        case Color::Red:
            SetConsoleTextAttribute(hConsole, RED_WIN_COLOR_CODE);
            break;
        case Color::Yellow:
            SetConsoleTextAttribute(hConsole, YELLOW_WIN_COLOR_CODE);
            break;
        case Color::Green:
            SetConsoleTextAttribute(hConsole, GREEN_WIN_COLOR_CODE);
            break;
        default:
            SetConsoleTextAttribute(hConsole, WHITE_WIN_COLOR_CODE);
        }
    #endif
    }

private:

#ifdef _WIN32
    static int const WHITE_WIN_COLOR_CODE = 7;
    static int const CYAN_WIN_COLOR_CODE = 11;
    static int const GREEN_WIN_COLOR_CODE = 2;
    static int const YELLOW_WIN_COLOR_CODE = 14;
    static int const RED_WIN_COLOR_CODE = 12;
#endif
};
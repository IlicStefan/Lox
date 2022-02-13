module lox;

import scanner;
import token;

import std.stdio;
import std.conv;
import std.algorithm;
import std.exception;
import std.string;
import std.file;
import std.utf;
import core.stdc.stdlib;

/** 
 * Lox
 */
class Lox
{
    private static bool hadError = false;

    /** 
    * start
    */
    public static void start(string[] args)
    {
        if (args.length > 2)
        {
            "Usage: dlox [script]".writeln;
            exit(64);
        }
        else if (args.length == 2)
        {
            runFile(args[1]);
        }
        else
        {
            runPrompt();
        }
    }

    private static void runFile(string path)
    {
        try
        {
            auto source  = readText(path);
            run(source);

            if(hadError)
            {
                exit(65);
            }
        }
        catch(Exception exception)
        {
            writefln("Error reading file: %s", path);
        }
    }

    private static void runPrompt()
    {
        string sourceLine;
        write("> ");
        while ((sourceLine = readln()) !is null)
        {
            run(sourceLine.chomp);
            hadError = false;
            write("> ");
        }
        writeln();
    }

    private static void run(string source)
    {
        auto scanner = new Scanner(source);
        auto tokens = scanner.scanTokens();

        foreach(token; tokens)
        {
            writeln(token);
        }
    }

    private static void error(int line, string message)
    {
        report(line, "", message);
    }

    private static void report(int line, string where, string message)
    {
        writefln("[line %d]Error%s: %s", line, where, message);
        hadError = true;
    }
}

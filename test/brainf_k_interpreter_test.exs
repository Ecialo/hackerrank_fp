defmodule BrainFuckInterpreterTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias Hackerrank.BrainFuck.{Memory, Interpreter}

  test "fibbo" do
    sample_program = """
    0 11
    $
    +++++++++++
    >+>>>>++++++++++++++++++++++++++++++++++++++++++++
    >++++++++++++++++++++++++++++++++<<<<<<[>[>>>>>>+>
    +<<<<<<<-]>>>>>>>[<<<<<<<+>>>>>>>-]<[>++++++++++[-
    <-[>>+>+<<<-]>>>[<<<+>>>-]+<[>[-]<[-]]>[<<[>>>+<<<
    -]>>[-]]<<]>>>[>>+>+<<<-]>>>[<<<+>>>-]+<[>[-]<[-]]
    >[<<+>>[-]]<<<<<<<]>>>>>[+++++++++++++++++++++++++
    +++++++++++++++++++++++.[-]]++++++++++<[->-<]>++++
    ++++++++++++++++++++++++++++++++++++++++++++.[-]<<
    <<<<<<<<<<[>>>+>+<<<<-]>>>>[<<<<+>>>>-]<-[>>.>.<<<
    [-]]<<[>>+>+<<<-]>>>[<<<+>>>-]<<[<+>-]>[<+>-]<<<-]
    """
    expected_output = "1, 1, 2, 3, 5, 8, 13, 21, 34, 55, \nPROCESS TIME OUT. KILLED!!!\n"
    assert capture_io(sample_program, &Interpreter.main/0) == expected_output
  end

  test "factor" do
    sample_program = """
    0 42
    $
    +++++++++++++++++++++++++++++++++           c1v33 : ASCII code of !
    >++++++++++++++++++++++++++++++
    +++++++++++++++++++++++++++++++             c2v61 : ASCII code of =
    >++++++++++                     c3v10 : ASCII code of EOL
    >++++++                        c4v7  : quantity of numbers to be calculated
    >                           c5v0  : current number (one digit)
    >+                          c6v1  : current value of factorial (up to three digits)
    <<                          c4    : loop counter
    [                           block : loop to print one line and calculate next
    >++++++++++++++++++++++++++++++++++++++++++++++++.  c5    : print current number
    ------------------------------------------------    c5    : back from ASCII to number
    <<<<.-.>.<.+                        c1    : print !_=_

    >>>>>                           block : print c6 (preserve it)
    >                           c7v0  : service zero
    >++++++++++                     c8v10 : divizor
    <<                          c6    : back to dividend
    [->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]           c6v0  : divmod algo borrowed from esolangs; results in 0 n d_n%d n%d n/d
    >[<+>-]                         c6    : move dividend back to c6 and clear c7
    >[-]                            c8v0  : clear c8

    >>                          block : c10 can have two digits; divide it by ten again
    >++++++++++                     c11v10: divizor
    <                           c10   : back to dividend
    [->-[>+>>]>[+[-<+>]>+>>]<<<<<]              c10v0 : another divmod algo borrowed from esolangs; results in 0 d_n%d n%d n/d
    >[-]                            c11v0 : clear c11
    >>[++++++++++++++++++++++++++++++++++++++++++++++++.[-]]c13v0 : print nonzero n/d (first digit) and clear c13
    <[++++++++++++++++++++++++++++++++++++++++++++++++.[-]] c12v0 : print nonzero n%d (second digit) and clear c12
    <<<++++++++++++++++++++++++++++++++++++++++++++++++.[-] c9v0  : print any n%d (last digit) and clear c9

    <<<<<<.                         c3    : EOL
    >>+                         c5    : increment current number
                                block : multiply c6 by c5 (don't preserve c6)
    >[>>+<<-]                       c6v0  : move c6 to c8
    >>                          c8v0  : repeat c8 times
    [
    <<<[>+>+<<-]                        c5v0  : move c5 to c6 and c7
    >>[<<+>>-]                      c7v0  : move c7 back to c5
    >-
    ]
    <<<<-                           c4    : decrement loop counter
    ]
    """
    expected_output = """
    0! = 1
    1! = 1
    2! = 2
    3! = 6
    4! = 24
    5! = 120
    """
    assert capture_io(sample_program, &Interpreter.main/0) == expected_output
  end

  test "fizz-buzz" do
    sample_program = """
    0 8
    $
    >++++++++++[<++++++++++>-]<[>+>[-]>++++++++++[<++++++++++>-]<+<<[->>->+<<<]>>>
    [-<<<+>>>]<>>+++<<[->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]>[-<+>]+>[-]>[<<->>[-]]>[-]
    <<<[[-]++++++++++[>++++++++++<-]>++.+++.[-]<[-]+++++++++++[>+++++++++++<-]>+..
    [-]<[-]<<[-]>>]<>>+++++<<[->+>-[>+>>]>[+[-<+>]>+>>]<<<<<<]>[-<+>]+>[-]>[<<->>[
    -]]>[-]<<<[[-]+++++++++[>+++++++++++<-]>-.[-]<[-]+++++++++[>+++++++++++++<-]>.
    +++++..[-]<[-]<<[-]>>]<<[[-]>>++++++++++<[->-[>+>>]>[+[-<+>]>+>>]<<<<<]>[-]>>[
    >++++++++[<++++++>-]<.[-]]<>++++++++[<++++++>-]<.[-]<<<]>[-]++++++++++.[-]<[-]
    <-]
    """
    expected_output = """
    1
    2
    fizz
    4
    buzz
    fizz
    7
    8
    fizz
    buzz
    11
    fizz
    13
    14
    fizzbuzz
    16
    17
    fizz
    19
    buzz
    fizz
    22
    23
    fizz
    buzz

    PROCESS TIME OUT. KILLED!!!
    """
    assert capture_io(sample_program, &Interpreter.main/0) == expected_output
  end

  @tag :o100_001
  test "fucking 100_001" do
    sample_program = """
    Conqueror of British Empire (CWE). All hail Idi Amin!!!$
    This will contain excatly 100001 operations
    Should result into proess kill
    +++++
    [>
        ++++++++
        [>
            ++++++++++
            [
                >
                ++++++++++++
                >
                ++++++++++++
                >
                ++++++++++++
                >
                +++++++++++
                >
                +++++++++++
                <<<<<
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            <<<<<
            <-
        ]
        <-
    ]

    ++++++++++++++
    [
        >
        +++++++++++++++
        <-
    ]
    >
    [
        -
    ]
    <
    ,.,+.
    """
    expected_output = "C\nPROCESS TIME OUT. KILLED!!!\n"
    [inpt, program] = String.split(sample_program, "$")
    program = Interpreter.parse(program)
    {_, _, operations} =
      Enum.reduce_while(program, {Memory.new(), inpt, 0}, &Interpreter.evaluate/2)
    assert operations == 100_001
    assert capture_io("\n" <> sample_program, &Interpreter.main/0) == expected_output
  end

  @tag :simple
  test "22 ops" do
    program = Interpreter.parse("++[>,+++.<-]")
    mem = Memory.new()
    {_, _, operations} =
      Enum.reduce_while(program, {mem, "pm", 0}, &Interpreter.evaluate/2)
    assert operations == 22
  end

  @tag :o100_000
  test "exactly 10**5" do
    sample_program = """
    Conqueror of British Empire (CWE). All hail Idi Amin!!!$
    This will contain excatly 10^5 operations
    +++++
    [>
        ++++++++
        [>
            ++++++++++
            [
                >
                ++++++++++++
                >
                ++++++++++++
                >
                ++++++++++++
                >
                +++++++++++
                >
                +++++++++++
                <<<<<
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            >
            [
                -
            ]
            <<<<<
            <-
        ]
        <-
    ]

    ++++++++++++++
    [
        >
        +++++++++++++++
        <-
    ]
    >
    [
        -
    ]
    <
    ,.,.
    """
    expected_output = "Co"
    [inpt, program] = String.split(sample_program, "$")
    program = Interpreter.parse(program)
    {_, _, operations} =
      Enum.reduce_while(program, {Memory.new(), inpt, 0}, &Interpreter.evaluate/2)
    assert operations == 100_000
    assert capture_io("\n" <> sample_program, &Interpreter.main/0) == expected_output
  end

end

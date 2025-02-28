app "random-numbers"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br",
        rand: "https://github.com/lukewilliamboswell/roc-random/releases/download/0.0.1/x_XwrgehcQI4KukXligrAkWTavqDAdE5jGamURpaX-M.tar.br",
    }
    imports [
        pf.Stdout,
        rand.Random,
    ]
    provides [main] to pf

# Print a list of 10 random numbers in the range 25-75 inclusive.
main =

    # Initialise "randomness"
    initialSeed = Random.seed 42

    # Create a generator for values from 25-75 (inclusive)
    generator = Random.int 25 75

    # Create a list of random numbers
    result = randomList initialSeed generator

    # Format as a string
    numbersListStr =
        result.numbers
        |> List.map Num.toStr
        |> Str.joinWith ","

    Stdout.line "Random numbers are: \(numbersListStr)"

# Generate a list of numbers using the seed and generator provided
# WARNING: likely NOT cryptograhpically secure
randomList = \initialSeed, generator ->
    List.range { start: At 0, end: Before 10 }
    |> List.walk { seed: initialSeed, numbers: [] } \state, _ ->

        # Use the generator to get a new seed and value
        random = generator state.seed

        # Update seed so it can be used to generate the next value
        seed = random.state

        # Append the latest random value to the list of numbers
        numbers = List.append state.numbers random.value

        { seed, numbers }

# Word Count Validator

## Objective

A description of the problem can be found at [this Animoto repository](https://github.com/animoto/platform_engineer_interview). The objective of this repo is to provide a possible implementation. A number of possible feature implementations and strategies will be discussed here. A viable subset of the features is implemented in code. Erring on the side of not trying to solve a problem you don't have.

To run the code:


        # You can get everything installed using
        bundle install

        # Run the server using
        ruby app.rb

        # Run the test suite via
        rspec


## Strategies and Considerations

Troll aliens are really bad at counting words. This will take time to change and we will probably notice that they are improving. This won't prevent them from downloading some code to help them fake out our CAPTCHA system. Some things we should consider when building our system:

1. A way to verify that they are sending back a response to what we sent and not just submitting a valid answer. A hash of the payload combined with a secret passphrase is one simple approach. Including their IP address before generating the hash assures a unique hash per client. Including a random or changing element in the passphrase will mean the same list of words will have a different hash over time (expiring hashes).
2. This is functioning on a a galactic scale, the less state required the better to maintain performance.
3. If performance is a concern or becomes an issue, each server should pre-generate a certain number of random text strings and exclusions (i.e. 1,000). When the number of remaining cached strings gets too low (i.e. 100), refill the cache.
4. While Trolls may be bad at counting words, given enough time to count they would probably get it right. There should be a time limit for responding with an answer.
5. Trolls are smart enough to comment in forums, they may be able to get help in the form of an automated script. We should have some measures to detect automation. Computers are faster than organisms and would likely respond faster than any orgasm, likely too fast.
6. Record additional behavior data points like mouse tracking, click locations, time to complete, behavior by region. This will help to define other measures that can be implemented to detect trolls and automation. It will also provide data to analyze retroactively in the event they do manage to break out CAPTCHA.

The MVP to implement in code:

1. Cheating protection. Include a hash key that will need to be submitted back with the answer. Key uses a secret passphrase and client IP address so is unique per client and text.
2. A stateless architecture.
3. The current text sample files are used. Exclusion words are random per request and can be up to n-1 words. A real implementation would use random source words per request.
4. Assumes words are separated by spaces.


Considerations and what's missing:

1. This is my first Ruby program.
2. It's missing unit tests.
3. The tests that are present are inefficient, not extensive, and don't cover edge cases.



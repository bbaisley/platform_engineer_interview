# Word Count Validator

## Objective

A description of the problem can be found at [this Animoto repository](https://github.com/animoto/platform_engineer_interview). The objective of this repo is to provide a possible implementation. A number of possible feature implementations and strategies will be discussed here. A viable subset of the features is implemented in code. Erring on the side of not trying to solve a problem you don't have.

## Strategies and Considerations

Trolls aliens are really bad at counting words. This will take time to change and we will probably notice that they are improving. This won't prevent them from downloading some code to help them fake out our CAPTCHA system. Some things we should consider when building our system:

1. A way to verify that they are sending back a response to what we sent and not just submitting a valid answer. A hash of the payload combined with a secret passphrase one simple approach. Including their IP address before generating the hash assures a unique hash per address. Including a random or changing element in the passphrase will mean the same list of words will have a different hash over time.
2. This is functioning on a a galactic scale, the less state required the better to maintain performance.
3. While they may be bad at counting words, given enough time to count they would probably get it right. There should be a time limit for responding with an answer.
4. Trolls are smart enough to comment in forums, they may be able to get help in the form of an automated script. We should have some measures to detect automation. Computers are faster than organism and would likely respond faster than any orgasm, likely too fast.
5. Record additional behavior data points like mouse tracking, click locations, time to complete. This will help to define other measures that can be implemented to detect trolls and automation. It will also provide data to analyze retroactively in the event they do manage to break out CAPTCHA.

The MVP to implement in code:
1. Include a hash key that will need to be submitted back with the answer. The hash will be made up of the payload+passphrase+ip address.
2. A stateless architecture.



We want to verify that a client can count words. As such, we need a web service that supplies clients with a "test" and allows the client to submit an answer. If the client and the service were people, their conversation might go something like this:

> **Client**: Service, can you give me some words to count?
> 
> **Service**: Sure. Please count the frequency of the words in "The quick brown fox jumped over the lazy dog" but please ignore the words "the" and "dog".
> 
> **Client**: Ok, the original text was "The quick brown fox jumped over the lazy dog" and in this text, ignoring the words  "the" and "dog", "quick" appeared once, "brown" appeared once, "fox" appeared once, "jumped" appeared once, "over" appeared once, "lazy" appeared once, and "the" appeared twice.
> 
> **Service**: Sorry, that's wrong. Nice try space troll.
> 
> **Client**: Oops, what I meant was the original text was "The quick brown fox jumped over the lazy dog" and in this text, ignoring the words  "the" and "dog", "quick" appeared once, "brown" appeared once, "fox" appeared once, "jumped" appeared once, "over" appeared once, and "lazy" appeared once.
> 
> **Service**: Looks great.


## Requirements

Write a server that does 2 things

### 1. Respond to a client HTTP request

Respond to a client HTTP request with at least the following in the response body:

1. A random body of text. Some sample texts are included.
2. A list of some but not all words in that body of text (exception: texts with only one unique word should use an empty list)

### 2. Receive a client HTTP request

Receive a client HTTP request with at least the following in the request

1. A body of text
2. A list of some but not all words in that body of text (exception: texts with only one unique word should have an empty list)
3. A count of the frequency of every word in the body of text excluding words from the list

and respond with:

1. If the word frequency count is correct, then `200 OK`
2. If the word frequency count is incorrect or the request is otherwise invalid, then `400 Bad Request`

You are *not* required to write the client application, but you can assume that a client for this server should:

1. Request from 1
2. Count the frequency of each word in the given body of text minus all of the given exclusion words
3. Send to 2 the word frequency count result with the original response body from 1.

### Readme

Writing software in a fast-paced, independent environment involves discovering and resolving many ambiguities. Your ability to make good assumptions and trade-offs is key. Keep the objective of the assignment in mind when making such decisions. Please include a readme document in your submission that describes any assumptions or decisions.

### Tests

Quality assurance is *very important* for maintaining a successful defense against the alien trolls. Please include a means to automatically assert the correctness of your code. This can be unit tests that validate the correctness of individual small pieces of code or functional tests that verify expected responses from particular endpoints. However you choose to implement tests, it must be automated and simple to run. It should not be a matrix of complicated human-driven steps and comparisons.

## Guidelines

1. You should feel free to write your solution in whichever language you are most comfortable writing.
2. Style, algorithms, data structures, request/response format, etc. are all up to you. However, keep in mind that we will be looking at these choices.
2. If your service can run on a Unix environment (e.g. ) Mac OSX, then please include the following:
    1. Any installation instructions or notes to set up our Mac OSX laptops to run your server
    2. A script `./run` to start the server
    3. The server should run on `localhost:8000` and serve a single path `/`
3. If your service _cannot_ run on Mac OSX, then please run your server on a remote host and provide us the hostname, port, and path to access it.
4. An open ended task like this can be expanded and improved infinitely. One could work on it forever, continously making little tweaks here and there. Meanwhile, alien trolls continue to terrorize the internet. This project should take a few hours, but certainly no more than 8. Please set a maximum amount of time to work on this project and submit whatever you have by the end of that time window. If you have not finished to your own satisfaction, please explain everything that you would like to add in your Readme.
5. Treat this assignment as you would an actual work project and _write code as you would in the actual work place_. Please do not write code as you would for a research project in a theoretical quantum computer or as a proof of P=NP.

## Bonus

1. **Cheating Protection**: When the server receives text, exclusion words, and a word count from the client, it verifies that the text and exclusion words that it previously gave a client.
2. **Stateless/Idempotent**: Remove as much "state" as possible from the server. Any new request to the server does not depend on the state of a previous request.

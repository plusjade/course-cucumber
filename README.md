# Write your first cucumber test from the ground up

This is short course in implementing your first cucumber test.

We use a control test and build from there =)


# Add base files for cucumber setup.

Add cucumber to the Gemfile. [Bundler](http://bundler.io/) is a ruby gem manager which we'll use to install the cucumber gem and lock the version.

The `features/support/env.rb` file is a ruby file that gets loaded and execute whenever the cucumber environment starts up.

---

Install the bundle:

```run
$: bundle install

Using builder (3.2.2)
Using diff-lcs (1.2.5)
Using multi_json (1.9.2)
Using gherkin (2.12.2)
Using multi_test (0.1.1)
Using cucumber (1.3.14)
Using bundler (1.5.2)
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
```

Verify cucumber runs correctly:

```run
$ bundle exec cucumber

env.rb has loaded! O_o
0 scenarios
0 steps
0m0.000s
```
Note the message we put in `env.rb` is correctly being executed and displayed.


# Create our first cucumber feature.

The feature we need to build is for a user to mention another user in a comment and have the system notify users anytime they are mentioned in a comment.

Cucumber encourages us to write tests in natural language so here we'll mock up a high level explanation of our feature as well as a simple test to prove our feature works.

We really want to focus in on _this_ feature so rather than concentrate on how users create comments, let's put the comment in a vacuum and assert that a comment is capable of parsing and processing @mentions.

---

Verify the mentions feature is run:

```run
$: bundle exec cucumber

env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"             # features/mentions.feature:7
    Then the comment's mentions should include the user "jade" # features/mentions.feature:8

1 scenario (1 undefined)
2 steps (2 undefined)
0m0.012s

You can implement step definitions for undefined steps with these snippets:

Given(/^I write a comment with body "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^the comment's mentions should include the user "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
```

The output tells us we have 2 steps that are undefined and gives us snippets to help us define our steps.

# Add step definition scaffolds generated by cucumber.

The cucumber terminal output autogenerated some step definitions that match our @mentions feature in the previous step so we'll use those.

---

Verify the new steps are recognized:

```run
$: bundle exec cucumber

env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"             # features/step_defs.rb:1
      TODO (Cucumber::Pending)
      ./features/step_defs.rb:2:in `/^I write a comment with body "(.*?)"$/'
      features/mentions.feature:7:in `Given I write a comment with body "Hello @jade"'
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:5

1 scenario (1 pending)
2 steps (1 skipped, 1 pending)
0m0.008s
```
The output now tells us we have 1 skipped step and 1 pending step.


# Implement Comment class to handle @mentions feature.

A pending step does us no good because it is not testing anything. The steps are meant to encapsulate the code logic needed to carry out the given feature.

Since we have no code logic, we'll start by building out a `Comment` class that will support parsing and processing @mentions.

As per the language of the first step definition we need a way to make a comment with the incoming text assigned to its body. Note the very logical `comment.body` method now seems to correctly hold the given text.

---

Verify the code we just made:

```run
$: bundle exec cucumber

env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"             # features/step_defs.rb:1
      uninitialized constant Comment (NameError)
      ./features/step_defs.rb:2:in `/^I write a comment with body "(.*?)"$/'
      features/mentions.feature:7:in `Given I write a comment with body "Hello @jade"'
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6

Failing Scenarios:
cucumber features/mentions.feature:6 # Scenario: Comment has single @mention

1 scenario (1 failed)
2 steps (1 failed, 1 skipped)
0m0.007s
```

It seems `Comment` is not initialized; it means Cucumber is not aware of the `Comment` class we just made.

# Load comment file into the cucumber environment.

Remember the `env.rb` file is loaded when cucumber initializes its environment. We'll add the base directory to the load path which will allow us to load our comment class file into the cucumber environment.

---

```run
$: bundle exec cucumber

Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"             # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6
      TODO (Cucumber::Pending)
      ./features/step_defs.rb:7:in `/^the comment's mentions should include the user "(.*?)"$/'
      features/mentions.feature:8:in `Then the comment's mentions should include the user "jade"'

1 scenario (1 pending)
2 steps (1 pending, 1 passed)
0m0.008s
```

The output tells us our first step is indeed now working (seems to be green) but our second step is still pending.

# Add method to check mentions in comments.

Let's try to implement the second step just like we did the first step. `comment.mentions` seems like the most practical interface for returning the mentions on a comment.

---

Let's run the test again and see if our new code helped:

```run
$: bundle exec cucumber

env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"             # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6
      undefined local variable or method `comment' for #<Object:0x007ffa249d33b8> (NameError)
      ./features/step_defs.rb:7:in `/^the comment's mentions should include the user "(.*?)"$/'
      features/mentions.feature:8:in `Then the comment's mentions should include the user "jade"'

Failing Scenarios:
cucumber features/mentions.feature:6 # Scenario: Comment has single @mention

1 scenario (1 failed)
2 steps (1 failed, 1 passed)
0m0.012s
```

The output tells us `comment` is not defined anywhere. =/

# Share state across step definitions.

Cucumber is right. Since all step definitions are just ruby blocks, any local variables assigned in the block are only scoped to that particular code block.

We need a way to share state _across_ these step definitions. Well cucumber is not so complicated; all the code running in the cucumber environment is running in the _same_ environment,
so you are safe to treat cucumber like any basic ruby environment.

We'll create instance variables which will persist across the environment for the duration of the cucumber environment instance.

The first step will run and set `@comment`. Any steps after will now have access to `@comment`.

---

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6


1 scenario (1 passed)
2 steps (2 passed)
0m0.009s
```

The output shows finally that our test has passed! But are we really testing our code?


# Use rspec to assert arbitrary result expectations.

The tests pass but there is no actual _test_ in our code! We'll add [rspec-expectations](https://github.com/rspec/rspec-expectations:#readme) in order to assert expectations against our code logic.

- https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
- https://github.com/rspec/rspec-expectations#readme

---

Update the bundle with rspec:

```
$: bundle install
Using builder (3.2.2)
Using diff-lcs (1.2.5)
Using multi_json (1.9.2)
Using gherkin (2.12.2)
Using multi_test (0.1.1)
Using cucumber (1.3.14)
Using rspec-core (2.14.7)
Using rspec-expectations (2.14.5)
Using rspec-mocks (2.14.6)
Using rspec (2.14.1)
Using bundler (1.5.2)
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
```

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6
      undefined method `include?' for nil:NilClass (NoMethodError)
      ./features/step_defs.rb:7:in `/^the comment's mentions should include the user "(.*?)"$/'
      features/mentions.feature:8:in `Then the comment's mentions should include the user "jade"'

Failing Scenarios:
cucumber features/mentions.feature:6 # Scenario: Comment has single @mention

1 scenario (1 failed)
2 steps (1 failed, 1 passed)
0m0.005s
```

The output is telling us `include?` is not defined on `nil`. Looking at the code, the `nil` in this case is what `comment.mentions` is returning.


# Implement the mentions method on a comment.

We'll implement `comment#mentions` to split the body text on spaces giving us an array of words. Any word that starts with `@` will be processed as a mention.

---

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6
      expected ["@jade"] to include "jade" (RSpec::Expectations::ExpectationNotMetError)
      ./features/step_defs.rb:7:in `/^the comment's mentions should include the user "(.*?)"$/'
      features/mentions.feature:8:in `Then the comment's mentions should include the user "jade"'

Failing Scenarios:
cucumber features/mentions.feature:6 # Scenario: Comment has single @mention

1 scenario (1 failed)
2 steps (1 failed, 1 passed)
0m0.004s
```

Here we see we almost got the correct name but we forgot to compensate for the actual `@` signifier token.

# Fix @ character staying attached to usernames.

The easiest thing to do is just drop `@` from the mentioned word.

---

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6

1 scenario (1 passed)
2 steps (2 passed)
0m0.003s
```


# Add a feature for mentioning more than one user.

So far so good, but comments should probably support multiple user @mentions right?

Let's write a new scenario where comments have multiple mentions.

---

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6

  Scenario: Comment has multiple @mentions                                     # features/mentions.feature:10
    Given I write a comment with body "Hello @jade and @sam, how is it going?" # features/step_defs.rb:1
      Hello @jade and @sam, how is it going?
    Then the comment's mentions should include the users "jade" and "sam"      # features/mentions.feature:12

2 scenarios (1 undefined, 1 passed)
4 steps (1 undefined, 3 passed)
0m0.005s

You can implement step definitions for undefined steps with these snippets:

Then(/^the comment's mentions should include the users "(.*?)" and "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end
```


# Add new step definition for multiple @mentions scenario.

As before, we haven't actually implemented the step definition so we'll use cucumber's suggestion and add it.

We'll also implement the code logic to verify that `comment.mentions` will correctly include multiple mentions.

---

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6

  Scenario: Comment has multiple @mentions                                     # features/mentions.feature:10
    Given I write a comment with body "Hello @jade and @sam, how is it going?" # features/step_defs.rb:1
      Hello @jade and @sam, how is it going?
    Then the comment's mentions should include the users "jade" and "sam"      # features/step_defs.rb:10
      expected ["jade", "sam,"] to include "sam" (RSpec::Expectations::ExpectationNotMetError)
      ./features/step_defs.rb:12:in `/^the comment's mentions should include the users "(.*?)" and "(.*?)"$/'
      features/mentions.feature:12:in `Then the comment's mentions should include the users "jade" and "sam"'

Failing Scenarios:
cucumber features/mentions.feature:10 # Scenario: Comment has multiple @mentions

2 scenarios (1 failed, 1 passed)
4 steps (1 failed, 3 passed)
0m0.007s
```

We are close but the test failed! It seems we forgot to account for characters that are not meant to be part of user names.


# Mentions should include only word characters.

Applications should always sanitize usernames so we are going to restrict usernames to contain only word characters.

---

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6

  Scenario: Comment has multiple @mentions                                     # features/mentions.feature:10
    Given I write a comment with body "Hello @jade and @sam, how is it going?" # features/step_defs.rb:1
      Hello @jade and @sam, how is it going?
    Then the comment's mentions should include the users "jade" and "sam"      # features/step_defs.rb:10

2 scenarios (2 passed)
4 steps (4 passed)
0m0.005s
```

The tests pass!


# Refactor the step_defs to be more DRY and reusable.

Something is off about the step definitions. It seems we are getting a bit redundant. Let's try to refactor and clean up the code.

Note the `?:` regular expression syntax allows us to omit the match from getting captured. Otherwise our methods would have to take two arguments, the first just being a useless placeholder.

---

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6

  Scenario: Comment has multiple @mentions                                     # features/mentions.feature:10
    Given I write a comment with body "Hello @jade and @sam, how is it going?" # features/step_defs.rb:1
      Hello @jade and @sam, how is it going?
    Then the comment's mentions should include the users "jade, sam"           # features/step_defs.rb:6

2 scenarios (2 passed)
4 steps (4 passed)
0m0.005s
```


# Add failing test to account for case mismatches.


---

```
$: bundle exec cucumber
env.rb has loaded! O_o
Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention                        # features/mentions.feature:6
    Given I write a comment with body "Hello @jade"            # features/step_defs.rb:1
      Hello @jade
    Then the comment's mentions should include the user "jade" # features/step_defs.rb:6

  Scenario: Comment has multiple @mentions                                     # features/mentions.feature:10
    Given I write a comment with body "Hello @jade and @sam, how is it going?" # features/step_defs.rb:1
      Hello @jade and @sam, how is it going?
    Then the comment's mentions should include the users "jade, sam"           # features/step_defs.rb:6

  Scenario: Comment has multiple @mentions of varying case                     # features/mentions.feature:14
    Given I write a comment with body "Hello @Jade and @SAM, how is it going?" # features/step_defs.rb:1
      Hello @Jade and @SAM, how is it going?
    Then the comment's mentions should include the users "jade, sam"           # features/step_defs.rb:6
      expected ["Jade", "SAM"] to include "jade" (RSpec::Expectations::ExpectationNotMetError)
      ./features/step_defs.rb:10:in `block (2 levels) in <top (required)>'
      ./features/step_defs.rb:9:in `each'
      ./features/step_defs.rb:9:in `/^the comment's mentions should include the (?:user|users) "(.*?)"$/'
      features/mentions.feature:16:in `Then the comment's mentions should include the users "jade, sam"'

Failing Scenarios:
cucumber features/mentions.feature:14 # Scenario: Comment has multiple @mentions of varying case

3 scenarios (1 failed, 2 passed)
6 steps (1 failed, 5 passed)
0m0.008s
```


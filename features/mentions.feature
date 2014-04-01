Feature: User mentions
  As a social butterfly 
  I want to mention my friends in comments I create
  so they can be notified and interact with me.

  Scenario: Comment has single @mention
    Given I write a comment with body "Hello @jade"
    Then the comment's mentions should include the user "jade"
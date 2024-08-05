---
title: "Proving The Concept"
description: "When it comes to software engineering, a good proof of concept can 
go a long way in illustrating solutions. But what makes a good proof of concept? 
What should we consider? Let's dive into a more philosophical topic and discuss."
publishDate: 2021-07-01
---

# Proving The Concept

When it comes to software engineering, a good proof of concept can
go a long way in illustrating solutions. But what makes a good proof of concept?
What should we consider? Let's dive into a more philosophical topic and discuss.

## Why?

A proof of concept can help you investigate potential improvements without
committing to a fully fleshed-out solution. You can quickly discover potential
issues and pitfalls early in the development cycle.

Another purpose of a proof of concept is to illustrate a solution in
simplified form. As such, it can be a great tool to show non-tech
stakeholders the "basic idea."

## How?

First up. A culture of innovation is needed, with ample time available to explore
issues, learn what needs improvement, and creatively brainstorm. Issues in code
and architecture should be well known and open for improvement.

Good examples of when a proof of concept can be useful is when unit testing a
legacy system. I have been working on this recently. We discovered that our
test coverage is almost nonexistent. In learning where to start, I began
digging into our existing setup to find that we have a broken implementation of
PHPUnit, where tests are automatically generated that:

(a) Don't test anything
(b) Fail.

My proof of concept (without sharing proprietary code) began with a simple test
case, which tests the functionality of a class.

Something along these lines (completely made up code):

### Test Subject

```php
class GetData() {
  // Sometimes you need to modify the code and that's okay. This constructor is
  // written to allow injection of test data, instead of having to fetch data
  // from an external data source.
  public function __construct($data=null) {
    $this->data = $data
  }

  public function init() {
    $data = new FetchFromExternalDataSource() ?? $this->data;

    ...

    // The init method is running a sort. That is easily testable functionality.
    usort($data function($a, $b){
      return $a["id"] <=> $b["id"];
    });

    ...

    // Oh look! We can test that the returned data is wrapped in the expected
    // object.
    return new DataObject($data);
  }
}
```

### Test Case

```php
class GetTests() {
  public function setUp() {
    $this->data = [
      [
        "id" => "2",
        "name" => "Item 2"
      ],
      [
        "id" => "1",
        "name" => "Item 1"
      ]
    ];
  }

  public function tearDown() {
    unset($this->data);
  }

  public function testResultIsInstanceOfDataObject() {
    // Create a test object with mocked data passed to the constructor
    $get = new Get($this->data);
    $result = $get->init();

    $this->assertInstanceOf(DataObject::class, $result);
  }

  public function testResultsAreSortedDescending() {
    $get = new Get($this->data);
    $result = $get->init();

    $this->assertEquals("1", $result[0]->id);
  }

}
```

The example above, while semi-fictional, should illustrate how you can openly
brainstorm and create a tangible example. There would likely be a lot of
"follow-up" as problems and shortcomings arise. But that is precisely the point.
Problems are discovered early in the development cycle. That way, you are
better prepared to write more maintainable solutions.

## What to Avoid?

A proof of concept should be as simplified a case as possible. It ought to be
able to demonstrate the purpose and benefits, but not be overly concerned with
edge cases.

A proof of concept should not be considered an "endgame" and should be open
to significant change if/when the implementation of the solution happens.

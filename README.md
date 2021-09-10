# Archivable

The Archivable framework is a lightweight, opinionated protocol for quick persistence and retrieval. There are many things that Archivable does not do. But here's what you get:

```
private struct User: Archivable {
	let name: String
	let age: Int
}

try? User(name: "Nice Guy", age: 28).archive()

...

let niceGuy = User.retrieve()
```

Did you catch that? Simply by conforming to `Archivable`, the developer can now easily persist and retrieve the `User` struct with a single line each.

There are a lot of opinions in this framework. Here's some:

- All encoding and decoding goes through JSON
- The encoding location for all objects will go to the same location
- It is a developer task to ensure that data migration happens correctly
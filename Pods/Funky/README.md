
# Funky

The documentation (courtesy of [realm/jazzy](https://github.com/realm/jazzy)) is available here: <https://brynbellomy.github.io/Funky>

Master branch is currently compatible with: **Swift 1.2** (although at the time of this writing, you have to do one quick-fix in LlamaKit's `Result.swift` due to breaking changes in 1.2).

Funky is a bunch of functional programming stuff for Swift.  I intend to de-jankify this README + repo in the near future, so bear with me.

This is my way of learning about FP and really shouldn't be considered safe for production.  I haven't finished writing tests for all of the included functions, and I would gladly welcome pull requests.

README coming soon.  (Honestly it's just a **shitload** of basic functions for basic types, collections (including strings), for `LlamaKit`'s `Result` type, etc.  Use whatever seems useful.)

# install

Make sure you have the latest pre-release version of [CocoaPods](http://cocoapods.org) (`gem install cocoapods --pre`), which has Swift support.  At the time of this writing, that would be `0.36.0.beta.1`.

Add to your `Podfile`:

```ruby
pod 'Funky'
```

And then from the shell:

```sh
$ pod install
```


# contributors / authors


bryn austin bellomy < <bryn.bellomy@gmail.com> >

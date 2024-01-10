# InetCidr Changelog

### Version: 1.0.6 (Jan 10, 2024)

```
Docs: Updated README to not use deprecated functions
```

### Version: 1.0.6 (Jan 10, 2024)

```
- Deprecated: InetCidr.parse/1 (Use InetCidr.parse_cidr!/1 instead)
- Deprecated: InetCidr.parse/2 (Use InetCidr.parse_cidr!/2 instead)
- Code: Added InetCidr.parse_cidr/2
- Code: Added InetCidr.parse_cidr!/2
- Code: Added InetCidr.parse_address/1 which complements the existing InetCidr.parse_address!/1
```

### Version: 1.0.5 (Jan 9, 2024)

```
- Compiler warnings: Fixed deprecation warning for `use Bitwise`
- Compiler warnings: Fixed deprecation warning for `use Config`
- Dependencies: Updated `ex_doc` version
```

### Version: 1.0.4 (Aug 30, 2018)

```
- Bugfix: Fix pattern match to use `48` instead of `49`
```

### Version: 1.0.3 (Aug 8, 2018)

```
- Compiler warnings: Replace `String.to_char_list` with `String.to_charlist` to fix compiler warning
```

### Version: 1.0.2 (Feb 3, 2017)

```
- Misc: Update `contributors` to `maintainers` in mix.exs
- Dependencies: Update `ex_doc` version used for documenation generation
- Compiler Warnings: In mix.exs to use parens in function calls to fix compiler warnings
```

### Version: 1.0.1 (July 17, 2015)

```
- Code: Fix hard coded bmask to use `rem` (no behavioral change)
- Misc: Update description in mix.exs to remove unnecessary text
```

### Version: 1.0.0 (July 17, 2015)

```
- Initial release 🎉
```
# Vulcano

Tired of job hunting? Let's fight capitalism and drive all HR people crazy...
The bourgeoisie use software tools to filter us? OK let's turn the tables and fuck them up by
developing software bots that shall apply to every single job on earth.

This Ruby script is basically for angel.co website, however, I am planning
to add driver classes for other websites (like indeed.ca). Feel free
to send me a pull request if you would like to add something!

## Credit

The angel.co driver source code is based on a rails program developed
by jmopr: https://github.com/jmopr/job-hunter

### Prerequisites

Before you run the script, you need to install ruby if it is not installed.
Install the following gems:

```
    $ gem install capybara
```

### Configuration

You need to setup a YAML configuration file before you run the script.
Refer to 'example.yml' for an example configuration file.

### Running

You only need to pass your configuration file name as an argument:

```
    $ ./vulcano <path-to-config-file.yml>
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


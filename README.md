# rotp

* **Version:** 1.0-0
* **URL**: https://github.com/wrathematics/rotp
* **Status:** [![Build Status](https://travis-ci.org/wrathematics/rotp.png)](https://travis-ci.org/wrathematics/rotp)
* **License:** [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause)
* **Author:** Drew Schmidt and Christian Heckendorf

A [Time-based One-Time Password](https://en.wikipedia.org/wiki/Time-based_One-time_Password_algorithm) (TOTP) implementation similar in spirit to [Google Authenticator](https://en.wikipedia.org/wiki/Google_Authenticator).



## Installation

<!-- You can install the stable version from CRAN using the usual `install.packages()`:

```r
install.packages("rotp")
``` -->

The development version is maintained on GitHub:

```r
remotes::install_github("wrathematics/rotp")
```

You will need a system installation of OpenSSL to build the package from source.



## How to Use the Package

You will need to have an ssh key that the openssl package can find (try `openssl::my_pubkey()`). If that works then:

1. Set up your secret key database with `otpdb()`.
2. Run the authenticator with `auth()`.

Each of these functions runs an interactive REPL for either managing keys (adding, deleting, ...) or getting one time passwords. You can also directly call the `hotp()` and `totp()` functions if you want.

The database file is located at `~/.rotpdb`. On Linux and Mac, this is in your home directory. On Windows, this is in "My Documents".



## Example

As mentioned above, the package should be used with the two interactive REPL functions `rotp::otpdb()` and `rotp::auth()`. The one you will call when you need to log in to some website is `rotp::auth()`. But it won't work until you set up your key database:

```r
rotp::auth()
## Error in rotp::auth() : 
##   No keys stored in db! Add some by first running otpdb()
```

So lets add some (fake) keys. The first time you run it, you have to consent to the creation of a file (mentioned above). If you do not consent, then the package doesn't work. Sorry.

```r
rotp::otpdb()
## To use the package, we need to create a persistent key database file. This file
## will be located at the path "/home/mschmid3/.rotpdb".
## 
## To proceed, enter YES (all caps). Entering anything else will halt the
## application.
## 
## Create db file? (YES/no): 
```

Once you agree (or if you agreed in the past and the file already exists), you will be greeted with the database REPL:

```
Choose an operation (Q/q to quit):
  1 - List   2 - Add   3 - Delete   4 - Show   5 - Sort   6 - Reset   7 - Help 
```

Choose the number of the option you want. So you might choose "7" to see a quick description of the options. We're going to add a key, so we'll pick "2". Let's suppose that this belongs to our bank and that the private key (the one they give you when you're setting up 2-factor authentication) is "qwerty":

```
$ 2
Enter a name for the key: My Bank
Enter the key: ******
```

As you can see, password entry is masked. Let's add another key. This time it will be for a shady cryptocurrency exchange that is mere weeks away from stealing all of your money (secret key "asdf").

```
$ 2
Enter a name for the key: A Shady Bitcoin Exchange
Enter the key: ****
```

With that done, we can enter "q" to exit the key REPL. We never need to run that again unless we want to add more keys, delete keys, or the like. To authenticate with a website, we call `rotp::auth()`, which brings up the authenticator REPL:

```
Pick a key or enter Q/q to exit:
  1 - My Bank
  2 - A Shady Bitcoin Exchange 
```

Once you make your choice, you may be asked for a private key passphrase. This should only happen if your ssh key is password protected (and this is the password that it's asking for). If your ssh key is not password protected, then it will jump straight to the OTP bit. Here's an example of what it looks like:

```
Ctrl+c to exit
 613454 (22 seconds remaining [========----------------------])
```

The number of seconds will count down as the little progress bar fills up. That's basically it.



## Disclaimer

While I have tried my hardest to make sure that everything is secure, I am not a security professional.

The package is licensed under the BSD 2-clause license. I would now like to call attention to a relevant part of the license:

>THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDER ``AS IS'' AND ANY EXPRESS OR
>IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
>MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
>EVENT SHALL COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
>INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
>BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
>DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
>LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
>OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
>ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

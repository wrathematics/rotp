# rotp

* **Version:** 1.0-0
* **URL**: https://github.com/RBigData/rotp
* **Status:** [![Build Status](https://travis-ci.org/RBigData/rotp.png)](https://travis-ci.org/RBigData/rotp)
* **License:** [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause)
* **Author:** Drew Schmidt

A [Time-based One-Time Password](https://en.wikipedia.org/wiki/Time-based_One-time_Password_algorithm) (TOTP) implementation similar in spirit to [Google Authenticator](https://en.wikipedia.org/wiki/Google_Authenticator).

The hotp and totp implementations (directly accessible via `rotp::hotp()` and `rotp::totp()`) are interfaces to [cpptotp](https://github.com/RavuAlHemio/cpptotp).



## Installation

<!-- You can install the stable version from CRAN using the usual `install.packages()`:

```r
install.packages("rotp")
``` -->

The development version is maintained on GitHub, and can easily be installed by any of the packages that offer installations from GitHub:

```r
### Pick your preference
devtools::install_github("wrathematics/rotp")
ghit::install_github("wrathematics/rotp")
remotes::install_github("wrathematics/rotp")
```



## Package Usage

You will need to have an ssh key that the openssl package can find (try `openssl::my_pubkey()`). If that works then:

1. Set up your secret key database with `otpdb()`.
2. Run the authenticator with `auth()`.

You can also directly call the `hotp()` and `totp()` functions if you want.

The database file is located at `~/.rotpdb`. On Linux and Mac, this is in your home directory. On Windows, this is in "My Documents".



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

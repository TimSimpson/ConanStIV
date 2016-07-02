#!/usr/bin/env bash
###############################################################################
#  Conan StIV
###############################################################################
#
# Builds various projects using Conan.
#
###############################################################################
set -e

bashi_base_command="${bashi_base_command:-$0}"
readonly c_root=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ "" == "${WINDIR}" ]; then
    readonly this_is_windows=
    function conan() {
        conan $@
    }
else
    readonly this_is_windows=true
    function conan() {
        cmd //c conan $@
    }
fi


function cmd_build() {
    # Build the main app
    cd "${c_root}/Main/App"
    mkdir -p build/release
    cd build/release
    if [ "" == "${this_is_windows}" ]; then
        conan install ../.. -s 'compiler=Visual Studio' -s compiler.version=12 -s build_type=Release -s arch=x86_64 -s os=Windows
    else
        cmd //c conan install ../.. -s compiler=Visual\ Studio -s compiler.version=12 -s build_type=Release -s arch=x86_64 -s os=Windows
    fi
    conan build ../..
}

function cmd_unit_tests() {
    # Run the meager unit tests.
    cd "${c_root}/Main/App"
    ./build/bin/macaroni.exe \
      --luaTests=Source/test/lua \
      --messagesPath=Source/main/resources/Messages.txt
}

function cmd_tests() {
    # Run the integration tests
    cd "${c_root}/Next/Tests"

    cavatappi -c -i
}

function cmd_refresh () {
    # Refresh the command list.
    mkdir -p Output
    python "${c_root}/BashiBazook/bashi.py" "${c_root}/mrun.sh" > "${c_root}/mrun.bashi-q"
    cp "${c_root}/mrun.bashi-q" "${c_root}/mrun.bashi"
}

bashi_help_preamble="
 :;;
 ;;;;.
 ;;;;;;
 ;;;';;;;
 ;;;'';;;;\`
 ;;;''';;;;;;                   @#@#
 :;;''''';;;;;;;:.              @':@
 \`;;;'''''''';;;;;;;            @'#@   #@@;  @++@\`
  ;;;'''''''''''';;;;;;\`     \`@@@,:@  @#,,@@+@;,,@.@@@
  :;;;''''''''''''';;;;;;,  ,@:,@@@@.#+,,#@@',@;,@\`#,+;
   ;;;;'''''''''''''';;;;;@#@,;@:,,,@@,,'@@@#@@@,# @@+@'
    ;;;;''''''''''''''';;;;#@:@,,,#@+',,@@::@,+@++@:,,,@
     ;;;;'''''''''''''''';;;#@:,,@+,#+,,@@::@@#:#@',:@@;  @@#
      .;;;'''''''''''''''';;;#,,'+,#@@@@@:@@@+,,,:@#@,@ , @,;@'
        :;;;''''''''''''''';;;#@@:@+,,,,#@;,@,,,;@#@,:@@+@@,,,@
          \`;;;;;'''''''''''';;;;'@,@@,,@',#@#,,:@,@+@@@@;@@,,:@
              ;;;;;''''''''''';;;:,@@,,@#,,+@,,@@@@#:,@@@@@,,@
               :;;;;;;'''''''''';;;;,,,:,,,,@;,@:,,;@@#+:@,,:@
                 \`;;;;;;;;'''''''';;;#@@@,,,,@,@,,::,,@'@:,,@\`
                    \`;;;;;;;;;''''''';@@@@,,,@@',@@@@,,@,,,##@
                      .@#';;;;;;;;;;'''@@@'@@#@,@;@,@','',+@,@
                      @@@:@;;'@,'@'#\`@@@;@@;,@@@@@#'@@+#'@@,,@
                      @\`.,,;;@,,@;,@#\`,@@',@@#,;@@,;+.:+@@@@@@@@
                      :@\`\`\`\`\`@,,@@,,;@#;,,:@+,,,,@\`\`\`\`\`\`\`\`\`\`\`\`@.
                        #\`\`\`\`@,,@.@',,,,;@@';,,,,@\`\`\`\`\`\`\`\`\`\`\`@
                        @+@@@@,,;#\`+@@@@@...#,,,,@'###@@@+\`\`@
                        @\`\`\`\`@,,,@@@#####+++@,,,,@,...\`\`\`\`\`:#
                        #,\`\`\`,@,,:@.\`\`\`\`\`\`\`\`@:,,,@\`\`\`\`\`\`\`\`\`@
                         @\`\`\`\`#@'@\`\`\`\`\`\`\`\`\`\`.@,,,:@\`\`\`\`\`\`\`.@
                         :@\`\`\`\`.#\`\`\`\`\`\`\`\`\`\`\`\`@',,,@,\`\`\`\`\`\`@
                          @\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`@:,,,@\`\`\`\`\`:@
                           @\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`@:,;@.\`\`\`\`@
                           @:\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`@@#\`\`\`\`\`;#
                            @\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`.@
                             @,\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`.@
                              #@@\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`\`@@.
                               .\`@@@@;,\`\`\`\`\`\`;;;;;;@@@,
                              @@@@@@@@@@@@@@@@@@@@@@@@@@
                              @@@@@@@@@@@@@@@@@@@@@@@@@@++\`
                                @@@@@@@@@@@@@@@@@@@@@@@@@++@@
                                '@@@@@@@@@@@@@@@@@@@@@@@@@@@.
                                ,#@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##;.

COMMANDS "

set +e
source "${c_root}/mrun.bashi" || set -e && cmd_refresh
set -e

source "${c_root}/mrun.bashi"

bashi_run $@

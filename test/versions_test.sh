. ./test/helper.sh
. ./share/ruby-install/versions.sh

versions_file="./test/versions.txt"
stable_file="./test/stable.txt"

function setUp()
{
	local commit="08cb86b18210e58fb9f85c0b4403e0a83f64fbf3"
	local download_url="https://raw.githubusercontent.com/postmodern/ruby-versions/$commit"

	wget -q -c -O "$versions_file" "$download_url/ruby/versions.txt"
	wget -q -c -O "$stable_file" "$download_url/ruby/stable.txt"
}

function test_is_valid_version()
{
	local version="2.0.0-p576"

        is_valid_version "$version" "$versions_file"

	assertEquals "did not find the version within the file" \
		     0 $?
}

function test_is_valid_version_with_invalid_version()
{
	local version="1.2.3"

        is_valid_version "$version" "$versions_file"

	assertEquals "did not return an error" 1 $?
}

function test_expand_version()
{
	local version="2.0"
	local expected_version="2.0.0-p481"

	assertEquals "did not return the last matching version" \
		     "$expected_version" \
		     "$(expand_version "$version" "$stable_file")"
}

function test_expand_version_with_empty_string()
{
	local expected_version="2.1.3"

	assertEquals "did not return the last version" \
		     "$expected_version" \
		     "$(expand_version "" "$stable_file")"
}

function test_expand_version_with_unknown_version()
{
	local unknwon_version="1.2.3"

	assertEquals "did not return an empty string" \
		     "" \
		     "$(expand_version "$unknown_version" "$stable_file")"
}

function test_resolve_version_with_exact_version()
{
	local version="2.0.0-p0"

	assertEquals "did not return the exact version" \
		     "$version" \
		     "$(resolve_version "$version" "$versions_file" "$stable_file")"
}

function test_resolve_version_with_short_version()
{
	local version="2.0"
	local expected_version="2.0.0-p481"

	assertEquals "did not return the exact version" \
		     "$expected_version" \
		     "$(resolve_version "$version" "$versions_file" "$stable_file")"
}

function test_resolve_version_with_unknown_version()
{
	local unknown_version="1.2.3"

	assertEquals "did not return the an empty string" \
		     "" \
		     "$(resolve_version "$version" "$versions_file" "$stable_file")"
}

function tearDown()
{
	rm "$versions_file"
	rm "$stable_file"
}

SHUNIT_PARENT=$0 . $SHUNIT2

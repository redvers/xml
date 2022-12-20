use "pony_test"

actor \nodoc\ Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestSimple)

class \nodoc\ iso _TestSimple is UnitTest
  """
  Initial stuffs
  """
  fun name(): String =>
    "simple"

  fun apply(h: TestHelper) =>
    h.assert_true(true)

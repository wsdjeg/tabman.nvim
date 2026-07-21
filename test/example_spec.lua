local lu = require('luaunit')

TestExample = {}

function TestExample:test_module_loads()
  local ok, tabman = pcall(require, 'tabman')
  lu.assertTrue(ok)
  lu.assertNotNil(tabman)
end

function TestExample:test_open_function_exists()
  local tabman = require('tabman')
  lu.assertNotNil(tabman.open)
  lu.assertEquals(type(tabman.open), 'function')
end

function TestExample:test_simple_arithmetic()
  lu.assertEquals(1 + 1, 2)
end

return TestExample


-- Program the Lagrande and Gregory-Newton methods for polynomial interpolation in a language of the student's choice. Place an operation counter and analyze which method used the least number of operations.
local function split(str, sep)
  local result = {}
  for s in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(result, tonumber(s))
  end
  return result
end


local function factorial(n)
  if n == 0 then return 1 end
  local result = 1
  for i = 2, n do
    result = result * i
  end
  return result
end

local function lagrande (n, x, y, z)
  local l_counter = 0
  local r = 0
  for i = 1, n do
    local c = 1
    local d = 1
    for j = 1, n do
      if i ~= j then
        c = c * (z - x[j])
        d = d * (x[i] - x[j])
      end
      l_counter = l_counter + 1
    end
    r = r + y[i] * (c/d)
    l_counter = l_counter + 1
  end
  return r, l_counter
end

local function gregoryNewton(n, x, y, z)
  local gn_counter = 0
  local deltay = {}
  for  i = 1, n do
    deltay[i] = {}
    deltay[i][1] = y[i]
    gn_counter = gn_counter + 1
  end
  for j = 2, n  do
    for i = 1, n - j + 1  do
      deltay[i][j] = deltay[i+1][j-1] - deltay[i][j-1]
      gn_counter = gn_counter + 1
    end
    gn_counter = gn_counter + 1
  end
  local h = x[2] - x[1]
  local u = (z - x[1]) / h
  local r = deltay[1][1]
  local t = 1
  for i = 2, n do
    t = t * (u - (i - 2))
    r = r + (t * deltay[1][i]) / factorial(i - 1)
    gn_counter = gn_counter + 1
  end
  return r, gn_counter
end

-- Abrir arquivo
local file = io.open("testes.txt", "r")

if not file then
  print("Erro ao abrir o arquivo de testes.")
  os.exit()
end

local test_num = 1

for line in file:lines() do
  local n_str, x_str, y_str, z_str = line:match("([^;]+);([^;]+);([^;]+);([^;]+)")

  if n_str and x_str and y_str and z_str then
    local n = tonumber(n_str)
    local x = split(x_str, ",")
    local y = split(y_str, ",")
    local z = tonumber(z_str)

    local r_lagrange, c_lagrange = lagrande(n, x, y, z)
    local r_newton, c_newton = gregoryNewton(n, x, y, z)

    print(("Teste %d: z = %.2f"):format(test_num, z))
    print(("  Lagrange       = %.6f (passos: %d)"):format(r_lagrange, c_lagrange))
    print(("  Gregory-Newton = %.6f (passos: %d)"):format(r_newton, c_newton))
    test_num = test_num + 1
  else
    print("Formato inválido na linha:", line)
  end
end

file:close()

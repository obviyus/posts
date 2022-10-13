local uuid = require("uuid")

if sysbench.cmdline.command == nil then
    error("Command is required. Supported commands: run")
end

local inserts = {"INSERT INTO benchmark.varchar_36 (uuid) VALUES ('%s')"}

function create_tables()
    con:query("DROP TABLE IF EXISTS benchmark.varchar_36")
    con:query("CREATE TABLE IF NOT EXISTS benchmark.varchar_36 (uuid VARCHAR(36) NOT NULL PRIMARY KEY)")
end

function execute_inserts()
    -- generate fake UUIDs
    local uu = uuid.uuid4()

    -- INSERT for new benchmark.varchar_36
    con:query(string.format(inserts[1], uu:uuid_str()))
end

-- Called by sysbench to initialize script
function thread_init()

    -- globals for script
    drv = sysbench.sql.driver()
    con = drv:connect()

    create_tables()
end

-- Called by sysbench when tests are done
function thread_done()

    con:disconnect()
end

-- Called by sysbench for each execution
function event()
    execute_inserts()
end

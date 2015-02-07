local prefix = ARGV[1]  or 'resque:'
local stats = {}

local prepend = function (x)
  return prefix ..  'worker:' .. x
end

local map = function (fn, array)
  local new_array = {}
  for i, v in ipairs(array) do
    new_array[i] = fn(v)
  end
  return new_array
end

-- Gather basic stats
stats['failed'] = redis.call('mget', prefix .. 'stat:failed')[1]
stats['processed'] = redis.call('mget', prefix .. 'stat:processed')[1]
stats['failing'] = redis.call('llen', prefix .. 'failed')

-- Count the number of workers and find which are active
local workers = redis.call('smembers', prefix .. 'workers')
local unpacked = unpack(map(prepend, workers))

stats['workers'] = workers
stats['processing'] = {}
local working = 0

if unpacked then
  local jobs = redis.call('mget', unpacked)

  for i, j in ipairs(jobs) do
    if j then
      working = working + 1

      local job = cjson.decode(j)
      local queue = stats[job.queue]

      -- attach this job on that worker
      stats['processing'][job.worker] = job

      if queue then
        queue.working = queue.working + 1
      else
        stats[job.queue] = {
          pending= 0,
          working= 1
        }
      end
    end
  end
end

stats['working'] = working

-- Find the number of pending jobs in each queue
stats['queues'] = {}
local queues = redis.call('smembers', prefix .. 'queues')
for i, q in ipairs(queues) do
  local len = redis.call('llen', prefix .. 'queue:' .. q)
  local queue = stats['queues'][q]
  if queue then
    queue.pending = len
  else
    stats['queues'][q] = {
      pending = len,
      working = 0
    }
  end
end

return cjson.encode(stats)
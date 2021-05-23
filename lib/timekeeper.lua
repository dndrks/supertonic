local Timekeeper={}

function Timekeeper:new(o)
  o=o or {}
  setmetatable(o,self)
  self.__index=self
  return o
end

function Timekeeper:init()
  self.lattice=lattice:new({
    ppqn=64
  })

  self.pattern={}
  for i=1,drummer_number do
    self.pattern[i]=self.lattice:new_pattern{
      action=function(t)
        --TODO: convert "t" to an actual beat
        drummer[i]:step(t)
      end,
      division=1/8
    }
  end

  self.lattice:start()
end


function Timekeeper:get_swing(i)
  return self.pattern[i].swing
end

function Timekeeper:start()
  self.lattice:hard_restart()
end

return Timekeeper

# 「ハギス」の移動距離を計算する
# - ハギスは静止しているが、最初の力を受けて移動を開始する
# - しばらくすると、第二の力を受けてハギスに加速がつく
# - 運動の一般法則を使って計算する
def distance_traveled(time)
  primary_acc = @primary_force / @mass
  primary_time = [time, @delay].min
  result = 0.5 * primary_acc * primary_time * primary_time
  secondary_time = time - @delay
  if (secondary_time > 0)
    primary_vel = primary_acc * @delay
    acc = (@primary_force + @secondary_force) / @mass
    result += primary_vel * secondary_time+ 5 * acc * secondary_time * 
      secondary_time
  end
  result
end

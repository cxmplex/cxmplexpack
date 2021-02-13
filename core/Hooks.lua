function cxmplex:CreateJumpHook()
  oJumpOrAscendStart = JumpOrAscendStart
  JumpOrAscendStart = function()
    if cxmplex.multijump_toggle and IsFalling() then
      SetCVar("AutoInteract", "0")
      cxmplex:StopFalling()
      StopMoving()
      if GetKeyState(0x41) then
        StrafeLeftStart()
      elseif cxmplex:GetKeyState(0x44) then
        StrafeRightStart()
      end
      if cxmplex:GetKeyState(0x57) then
        MoveForwardStart()
      end
      if cxmplex:GetKeyState(0x1) and cxmplex:GetKeyState(0x2) then
        MoveAndSteerStart()
      end
      oJumpOrAscendStart()
    else
      oJumpOrAscendStart()
    end
  end
end

function cxmplex:CreateChatHook()
  oSendChatMessage = SendChatMessage
  SendChatMessage = function(msg, ...)
    if string.sub(msg, 1, 1) == "." then
      cxmplex:RunCommand(string.sub(msg, 2))
      return
    end
    oSendChatMessage(msg, ...)
  end
end

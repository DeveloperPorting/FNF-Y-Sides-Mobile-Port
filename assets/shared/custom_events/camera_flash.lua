function onEvent(event, value1, value2, strumTime)
    if event == 'camera_flash' then
        if flashingLights then 
            cameraFlash('game', 'FFFFFF', value1, true) 
        end
    end
end
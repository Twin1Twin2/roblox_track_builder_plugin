
return function(state, action)
    state = state or {
        isOpen = false,
        menuName = "",
        onInstanceSelected = function() return true end
    }

    if (action.type == "CloseSelectInstanceMenu") then
        return {
            isOpen = false,
            menuName = "",
            onInstanceSelected = function() return true end
        }
    elseif (action.type == "OpenSelectInstanceMenu") then
        return {
            isOpen = true;
            menuName = action.menuName;
            onInstanceSelected = action.onInstanceSelected;
        }
    end

    return state
end
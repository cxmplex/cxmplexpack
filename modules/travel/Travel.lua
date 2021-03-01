local destinations = { "org", "cov", "odal", "dal", "orb" }

local travelHubPaths = {
  oribos = { -- OUTER: Current MAP
    lower = { -- INNER: Travel Hub to Destination
      {
        x = -1831.846,
        y = 1325.524,
        z = 5448.187,
        random = true,
        type = "waypoint",
        name = "Ring of Fates Portal",
      },
      {
        id = 365154,
        type = "interactable",
        name = "Portal to Lower Oribos"
      }
    },
    upper = {
      {
        x = -1833.868,
        y = 1324.689,
        z = 5268.780,
        random = true,
        type = "waypoint",
        name = "To Ring of Transference"
      },
      {
        id = 352745,
        type = "interactable",
        name = "Portal to Upper Oribos"
      }
    },
    orgrimmar = {
      {
        x = -1833.925,
        y = 1349.204,
        z = 5267.802,
        random = true,
        type = "waypoint",
        name = "Oribos Doorway to Portal"
      },
      {
        x = -1834.665,
        y = 1524.991,
        z = 5274.155,
        random = true,
        type = "waypoint",
        name = "Oribos Platform to Portal"
      },
      {
        x = -1858.872,
        y = 1537.616,
        z = 5274.757,
        random = false,
        type = "waypoint",
        name = "Oribos to Ogrimmar Portal"
      },
      {
        id = 353822,
        type = "interactable",
        name = "Portal to Ogrimmar"
      }
    }
  }
}

local mapIdNameMap = {
  [2222] = "oribos",
  [1] = "orgrimmar"
}

function cxmplex:Travel(destination)
  if destinations[destination] == nil then
    print("This destination (" .. destination .. ") is not supported.")
  end
  if not IsMounted() and not IsIndoors() then
    cxmplex:CallMount()
  end
  local currentMapId = GetMapId
end

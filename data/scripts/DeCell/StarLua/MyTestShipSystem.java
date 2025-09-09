package data.scripts.DeCell.StarLua;

import DeCell.StarLua.ShipSystems.LuaShipSystemBase;
import org.json.JSONException;

import java.io.IOException;

public class MyTestShipSystem extends LuaShipSystemBase {
    public MyTestShipSystem() throws JSONException, IOException {
        super.setLuaPath("luaSrc/DeCell/StarLuaTest/MyTestShipSystem.lua", "StarLuaTest");
    }
}

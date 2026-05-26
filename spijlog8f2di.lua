هذا هو سكربت Lua كامل لإنشاء زر تشغيل/إطفاء (Toggle) في Roblox:

local button = script.Parent
local isOn = false

local function onButtonClick()
    isOn = not isOn
    
    if isOn then
        button.BrickColor = BrickColor.new("Lime green")
        button.SurfaceGui.TextLabel.Text = "ON"
        print("تم تشغيل النظام")
    else
        button.BrickColor = BrickColor.new("Really red")
        button.SurfaceGui.TextLabel.Text = "OFF"
        print("تم إطفاء النظام")
    end
end

button.ClickDetector.MouseClick:Connect(onButtonClick)

لاحظ أن هذا السكربت يفترض:
1. وجود جزء (Part) كمزر
2. يحتوي على ClickDetector
3. يحتوي على SurfaceGui بداخله TextLabel
4. السكربت يجب وضعه كابن للجزء (Part)

يمكنك تعديل الألوان والنصوص حسب احتياجاتك.
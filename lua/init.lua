local has_colorizer, colorizer = pcall(require, "colorizer");

if (has_colorizer) then
colorizer.setup({
    '*';
}, { css = true; })
end


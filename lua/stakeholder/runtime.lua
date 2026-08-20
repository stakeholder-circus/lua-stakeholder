local catalog = require("stakeholder.catalog")
local json = require("stakeholder.json")

local M = {}

local function clone_array(values)
	local copy = {}
	for _, value in ipairs(values) do
		copy[#copy + 1] = value
	end
	return copy
end

local function success(payload, output_format)
	return { exit_code = 0, payload = payload, output_format = output_format or "json", stderr = "" }
end

local function failure(exit_code, message)
	return { exit_code = exit_code, payload = nil, output_format = nil, stderr = message }
end

local function parse_args(argv)
	local config = {
		devType = "backend",
		jargon = "medium",
		complexity = "medium",
		duration = "standard",
		alerts = false,
		project = "shareholder",
		minimal = false,
		team = "core",
		framework = "portable",
		seed = "default-seed",
		outputFormat = "text",
		noColor = false,
		trace = false,
		listValues = false,
		focusFamily = nil,
		experimentalProvider = nil,
		experimentalMode = nil,
		experimentalProfile = nil,
		experimentalPromptAsset = nil,
		experimentalPromptVersion = nil,
		experimentalPersonalizationProfile = nil,
		experimentalModel = nil,
		experimentalBaseUrl = nil,
		experimentalSessionFile = nil,
		experimentalStore = nil,
		experimentalBootstrapCommand = nil,
		experimentalDisableCache = false,
	}

	local index = 1
	while index <= #argv do
		local argument = argv[index]
		local next_value = argv[index + 1]

		if argument == "--list-values" then
			config.listValues = true
		elseif argument == "--alerts" then
			config.alerts = true
		elseif argument == "--minimal" then
			config.minimal = true
		elseif argument == "--no-color" then
			config.noColor = true
		elseif argument == "--trace" then
			config.trace = true
		elseif argument == "--experimental-disable-cache" then
			config.experimentalDisableCache = true
		elseif argument == "--dev-type" then
			config.devType = next_value
			index = index + 1
		elseif argument == "--jargon" then
			config.jargon = next_value
			index = index + 1
		elseif argument == "--complexity" then
			config.complexity = next_value
			index = index + 1
		elseif argument == "--duration" then
			config.duration = next_value
			index = index + 1
		elseif argument == "--project" then
			config.project = next_value
			index = index + 1
		elseif argument == "--team" then
			config.team = next_value
			index = index + 1
		elseif argument == "--framework" then
			config.framework = next_value
			index = index + 1
		elseif argument == "--seed" then
			config.seed = next_value
			index = index + 1
		elseif argument == "--output-format" then
			config.outputFormat = next_value
			index = index + 1
		elseif argument == "--focus-family" then
			config.focusFamily = next_value
			index = index + 1
		elseif argument == "--experimental-provider" then
			config.experimentalProvider = next_value
			index = index + 1
		elseif argument == "--experimental-mode" then
			config.experimentalMode = next_value
			index = index + 1
		elseif argument == "--experimental-profile" then
			config.experimentalProfile = next_value
			index = index + 1
		elseif argument == "--experimental-prompt-asset" then
			config.experimentalPromptAsset = next_value
			index = index + 1
		elseif argument == "--experimental-prompt-version" then
			config.experimentalPromptVersion = next_value
			index = index + 1
		elseif argument == "--experimental-personalization-profile" then
			config.experimentalPersonalizationProfile = next_value
			index = index + 1
		elseif argument == "--experimental-model" then
			config.experimentalModel = next_value
			index = index + 1
		elseif argument == "--experimental-base-url" then
			config.experimentalBaseUrl = next_value
			index = index + 1
		elseif argument == "--experimental-session-file" then
			config.experimentalSessionFile = next_value
			index = index + 1
		elseif argument == "--experimental-store" then
			config.experimentalStore = next_value
			index = index + 1
		elseif argument == "--experimental-bootstrap-command" then
			config.experimentalBootstrapCommand = next_value
			index = index + 1
		else
			return nil, string.format("Unknown argument '%s'.", tostring(argument))
		end

		index = index + 1
	end

	return config, nil
end

local function xor32(left, right)
	local result = 0
	local bit = 1
	for _ = 1, 32 do
		if (left % 2) ~= (right % 2) then
			result = result + bit
		end
		left = math.floor(left / 2)
		right = math.floor(right / 2)
		bit = bit * 2
	end
	return result
end

local function multiply32(left, right)
	local left_low = left % 65536
	local left_high = math.floor(left / 65536)
	local right_low = right % 65536
	local right_high = math.floor(right / 65536)
	local low = left_low * right_low
	local cross = ((left_high * right_low) + (left_low * right_high)) % 65536
	return (low + (cross * 65536)) % 4294967296
end

local function stable_hash(value)
	local hash = 2166136261
	for index = 1, #value do
		hash = xor32(hash, value:byte(index))
		hash = multiply32(hash, 16777619)
	end
	return hash
end

local function timestamp_for(seed, family, sequence)
	local base = stable_hash(seed .. "|" .. family)
	local seconds = (base + (sequence * 137)) % 86400
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local remainder = seconds % 60
	return string.format("2026-01-01T%02d:%02d:%02dZ", hours, minutes, remainder)
end

local function registry_payload()
	local families = {}
	for _, family in ipairs(catalog.generator_families) do
		families[#families + 1] = {
			id = family.id,
			registryId = family.registryId,
			rendererKey = family.rendererKey,
			tranche = family.tranche,
		}
	end

	return {
		complexities = clone_array(catalog.complexities),
		devTypes = clone_array(catalog.dev_types),
		experimentalFlags = clone_array(catalog.experimental_flags),
		experimentalModes = clone_array(catalog.experimental_modes),
		experimentalProviders = clone_array(catalog.experimental_providers),
		flags = clone_array(catalog.flags),
		generatorFamilies = families,
		jargonLevels = clone_array(catalog.jargon_levels),
		outputFormats = clone_array(catalog.output_formats),
		personalizationProfiles = clone_array(catalog.personalization_profiles),
		promptAssets = clone_array(catalog.prompt_assets),
	}
end

local function active_experimental_without_provider(config)
	return config.experimentalMode
		or config.experimentalProfile
		or config.experimentalPromptAsset
		or config.experimentalPromptVersion
		or config.experimentalPersonalizationProfile
		or config.experimentalModel
		or config.experimentalBaseUrl
		or config.experimentalSessionFile
		or config.experimentalStore
		or config.experimentalBootstrapCommand
		or config.experimentalDisableCache
end

local function ensure_experimental_supported(config)
	if config.experimentalProvider and config.experimentalProvider ~= "" then
		return failure(1, "experimental-provider is not implemented yet in lua-stakeholder")
	end

	if active_experimental_without_provider(config) then
		return failure(1, "experimental flags require --experimental-provider")
	end

	return nil
end

local function build_context(family, config)
	local context = {
		detail = family.rendererDetail,
		devType = config.devType,
		focusFamily = family.id,
		framework = config.framework,
		project = config.project,
		renderer = family.rendererKey,
		rendererKey = family.rendererKey,
		seed = config.seed,
		team = config.team,
		tranche = family.tranche,
	}

	context[family.contextKey] = family.contextValue
	return context
end

local function build_events(family, config, context)
	local base_prefix = string.gsub(family.id, "_", " ")
	local messages = {
		string.format("%s opens a deterministic planning lane for %s.", base_prefix, config.project),
		string.format(
			"%s keeps %s at %s complexity with %s.",
			base_prefix,
			config.devType,
			config.complexity,
			family.rendererKey
		),
		string.format("%s finalizes an auditable snapshot using %s.", base_prefix, context[family.contextKey]),
	}

	local event_types = { "session.start", "artifact.plan", "artifact.finish" }
	local events = {}

	for sequence = 1, #messages do
		events[#events + 1] = {
			eventType = event_types[sequence],
			message = messages[sequence],
			sequence = sequence,
			timestamp = timestamp_for(config.seed, family.id, sequence),
			context = {
				detail = family.rendererDetail,
				family = family.id,
				renderer = family.rendererKey,
				rendererKey = family.rendererKey,
				tranche = family.tranche,
			},
		}
	end

	return events
end

function M.run_table(argv)
	local config, parse_error = parse_args(argv)
	if not config then
		return failure(2, parse_error)
	end

	local experimental_failure = ensure_experimental_supported(config)
	if experimental_failure then
		return experimental_failure
	end

	if config.listValues then
		return success(registry_payload(), "json")
	end

	if not config.focusFamily or config.focusFamily == "" then
		return failure(2, "Missing required --focus-family.")
	end

	local family = catalog.find_family(config.focusFamily)
	if not family then
		return failure(2, string.format("Unknown focus family '%s'.", config.focusFamily))
	end

	local context = build_context(family, config)
	local payload = {
		complexity = config.complexity,
		context = context,
		devType = config.devType,
		events = build_events(family, config, context),
		family = family.id,
		minimal = config.minimal,
		outputFormat = config.outputFormat,
		project = config.project,
		registryId = family.registryId,
		seed = config.seed,
	}

	return success(payload, config.outputFormat)
end

local function render_text(payload)
	local lines = {
		string.format("family: %s", payload.family),
		string.format("renderer: %s", payload.context.rendererKey),
		string.format("project: %s", payload.project),
	}

	for _, event in ipairs(payload.events) do
		lines[#lines + 1] = string.format("%02d %s %s", event.sequence, event.timestamp, event.message)
	end

	return table.concat(lines, "\n")
end

function M.run(argv)
	local result = M.run_table(argv)
	if result.exit_code ~= 0 then
		return { exit_code = result.exit_code, stdout = "", stderr = result.stderr }
	end

	local stdout
	if result.output_format == "json" then
		stdout = json.encode(result.payload)
	else
		stdout = render_text(result.payload)
	end

	return { exit_code = 0, stdout = stdout, stderr = "" }
end

return M

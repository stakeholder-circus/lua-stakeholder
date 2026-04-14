package.path = table.concat({
	"./lua/?.lua",
	"./lua/?/init.lua",
	package.path,
}, ";")

local runtime = require("stakeholder.runtime")

local dedicated_families = {
	{ "code_analyzer", "analysisFocus", "classic-six.code_analyzer" },
	{ "data_processing", "dataWindow", "classic-six.data_processing" },
	{ "jargon", "languagePolicy", "classic-six.jargon" },
	{ "metrics", "signalBlend", "classic-six.metrics" },
	{ "network_activity", "transportMix", "classic-six.network_activity" },
	{ "system_monitoring", "telemetryScope", "classic-six.system_monitoring" },
	{ "agent_workflows", "coordinationMode", "modern-core.agent_workflows" },
	{ "platform_engineering", "platformSurface", "modern-core.platform_engineering" },
	{ "observability_ai_runtime", "runtimeSignals", "modern-core.observability_ai_runtime" },
	{ "delivery_preview_ops", "deliveryGuardrail", "modern-core.delivery_preview_ops" },
	{ "supply_chain_security", "supplyChainPosture", "modern-core.supply_chain_security" },
}

describe("lua stakeholder runtime", function()
	it("list-values exposes the full registry and dedicated renderer keys", function()
		local result = runtime.run_table({ "--list-values" })
		assert.are.equal(0, result.exit_code)
		assert.is_truthy(result.payload)
		assert.is_true(#result.payload.generatorFamilies >= 30)

		local by_id = {}
		for _, family in ipairs(result.payload.generatorFamilies) do
			by_id[family.id] = family
			assert.is_truthy(family.rendererKey)
		end

		assert.are.equal("classic-six.code_analyzer", by_id.code_analyzer.rendererKey)
		assert.are.equal("modern-core.delivery_preview_ops", by_id.delivery_preview_ops.rendererKey)
	end)

	for _, definition in ipairs(dedicated_families) do
		local family_id = definition[1]
		local context_key = definition[2]
		local renderer_key = definition[3]

		it(family_id .. " emits dedicated metadata", function()
			local result =
				runtime.run_table({ "--focus-family", family_id, "--output-format", "json", "--seed", "smoke" })
			assert.are.equal(0, result.exit_code)
			assert.are.equal(family_id, result.payload.family)
			assert.are.equal(renderer_key, result.payload.context.rendererKey)
			assert.is_truthy(result.payload.context[context_key])
			assert.are.equal(renderer_key, result.payload.events[1].context.rendererKey)
		end)
	end

	it("deterministic json stays stable for the same seed", function()
		local first =
			runtime.run({ "--focus-family", "platform_engineering", "--output-format", "json", "--seed", "same-seed" })
		local second =
			runtime.run({ "--focus-family", "platform_engineering", "--output-format", "json", "--seed", "same-seed" })

		assert.are.equal(0, first.exit_code)
		assert.are.equal(first.stdout, second.stdout)
	end)

	it("experimental provider flags fail fast", function()
		local result = runtime.run({ "--experimental-provider", "openai-compatible" })
		assert.are.equal(1, result.exit_code)
		assert.is_truthy(result.stderr:match("experimental%-provider is not implemented yet in lua%-stakeholder"))
	end)

	it("orphan experimental flags require a provider", function()
		local result = runtime.run({ "--experimental-model", "gpt-5.4" })
		assert.are.equal(1, result.exit_code)
		assert.is_truthy(result.stderr:match("experimental flags require %-%-experimental%-provider"))
	end)
end)

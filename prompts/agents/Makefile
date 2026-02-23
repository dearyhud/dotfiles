SHELL  := /bin/bash
.DEFAULT_GOAL := help

AGENTS_DIR   := $(HOME)/.claude/agents
CURDIR       := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
AGENT_FILES  := $(wildcard $(CURDIR)/0*.md)

.PHONY: install uninstall list architect planner engineer reviewer tester debugger sre help

# ── Install ───────────────────────────────────────────────────────────────────

install: ## Symlink all agents into ~/.claude/agents/ (run once per machine)
	@mkdir -p $(AGENTS_DIR)
	@for f in $(AGENT_FILES); do \
		name=$$(grep '^name:' $$f | head -1 | awk '{print $$2}'); \
		target=$(AGENTS_DIR)/$$name.md; \
		ln -sf $$f $$target; \
		echo "  linked   $$name  →  $$target"; \
	done

uninstall: ## Remove agent symlinks from ~/.claude/agents/
	@for f in $(AGENT_FILES); do \
		name=$$(grep '^name:' $$f | head -1 | awk '{print $$2}'); \
		target=$(AGENTS_DIR)/$$name.md; \
		rm -f $$target; \
		echo "  removed  $$target"; \
	done

list: ## Show installed agents and their symlink status
	@echo ""
	@echo "  Agent definitions in $(AGENTS_DIR):"
	@echo ""
	@for f in $(AGENT_FILES); do \
		name=$$(grep '^name:' $$f | head -1 | awk '{print $$2}'); \
		target=$(AGENTS_DIR)/$$name.md; \
		if [ -L $$target ]; then \
			echo "  ✓  $$name  (installed)"; \
		else \
			echo "  ✗  $$name  (not installed — run make install)"; \
		fi; \
	done
	@echo ""

# ── Launch (fallback — prefer /agents <name> after make install) ──────────────

architect: ## Launch Claude as the Architect (fallback — prefer /agents architect)
	claude --append-system-prompt "$$(cat $(CURDIR)/01-architect.md)"

planner: ## Launch Claude as the Planner (fallback — prefer /agents planner)
	claude --append-system-prompt "$$(cat $(CURDIR)/02-planner.md)"

engineer: ## Launch Claude as the Engineer (fallback — prefer /agents engineer)
	claude --append-system-prompt "$$(cat $(CURDIR)/03-engineer.md)"

reviewer: ## Launch Claude as the Reviewer (fallback — prefer /agents reviewer)
	claude --append-system-prompt "$$(cat $(CURDIR)/04-reviewer.md)"

tester: ## Launch Claude as the Tester (fallback — prefer /agents tester)
	claude --append-system-prompt "$$(cat $(CURDIR)/05-tester.md)"

debugger: ## Launch Claude as the Debugger (fallback — prefer /agents debugger)
	claude --append-system-prompt "$$(cat $(CURDIR)/06-debugger.md)"

sre: ## Launch Claude as the SRE (fallback — prefer /agents sre)
	claude --append-system-prompt "$$(cat $(CURDIR)/07-sre.md)"

# ── Help ──────────────────────────────────────────────────────────────────────

help:
	@echo ""
	@echo "  AI Agent Team"
	@echo ""
	@echo "  Setup"
	@grep -E '^(install|uninstall|list):.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  make %-14s %s\n", $$1, $$2}'
	@echo ""
	@echo "  Launch (fallback)"
	@grep -E '^(architect|planner|engineer|reviewer|tester|debugger|sre):.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  make %-14s %s\n", $$1, $$2}'
	@echo ""
	@echo "  After running make install, invoke agents directly in any Claude session:"
	@echo "  /agents architect   /agents planner   /agents engineer"
	@echo "  /agents reviewer    /agents tester    /agents debugger    /agents sre"
	@echo ""

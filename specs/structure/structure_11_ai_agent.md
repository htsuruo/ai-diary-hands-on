# 第11章 ハンズオン構成案: AI エージェント

## コンセプト
「自律性」の導入。単一のプロンプトではなく、複数の専門エージェント（Planning, Research, Reflection, Refinement）が協調してタスクを遂行するマルチエージェントシステムを構築します。

## 推奨ディレクトリ構成 (Functions 側)

```
functions/
├── src/
│   ├── agents/                     # [NEW] 専門エージェント群
│   │   ├── planningAgent.ts        # 計画立案
│   │   ├── researchAgent.ts        # 調査実行
│   │   ├── reflectionAgent.ts      # 結果分析・内省
│   │   └── refinementAgent.ts      # レポート作成
│   ├── tools/
│   │   └── webSearch.ts            # [NEW] 外部ツール (Tavily API)
│   └── flows/
│       └── researchAgentFlow.ts    # オーケストレーター
```

## 教育的ポイント

### 1. `functions/src/agents/*.ts`
**狙い**: 「役割（Role）」の明確化。1つの巨大なプロンプトですべてをやろうとするのではなく、タスクを分解し、それぞれに特化したエージェント（プロンプト + ロジック）を作る設計パターンを学びます。

### 2. `functions/src/tools/webSearch.ts`
**狙い**: AI に「目」を与える。外部 API (Tavily) を通じて、学習データに含まれていない最新情報を取得する能力の実装です。

### 3. `functions/src/flows/researchAgentFlow.ts`
**狙い**: オーケストレーション。各エージェントをどのように連携させるか（Plan -> Execute -> Reflect ループ）を制御フローとして記述します。

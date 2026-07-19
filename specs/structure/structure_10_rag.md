# 第10章 ハンズオン構成案: RAG (思い出アシスタント)

## コンセプト
「検索 (Retrieval)」と「生成 (Generation)」の結合。ベクトル検索の仕組みを理解し、過去のデータを AI の知識として活用する方法を学びます。

## 推奨ディレクトリ構成 (Functions 側)

```
functions/
├── src/
│   ├── retrievers/                 # [NEW] 検索ロジック
│   │   └── diaryRetriever.ts       # Firestore Vector Search 連携
│   ├── flows/
│   │   └── memoryAssistantFlow.ts  # RAG フロー
│   ├── prompts/
│   │   └── memory_assistant.prompt # コンテキストを受け取るプロンプト
│   └── scripts/                    # [NEW] ユーティリティ
│       └── seedDiaries.ts          # ダミーデータ投入 & Embedding 生成
```

## 教育的ポイント

### 1. `functions/src/retrievers/diaryRetriever.ts`
**狙い**: 検索（Retrieve）を独立したコンポーネントとして定義する。Genkit の `defineRetriever` を使い、検索ロジックを抽象化します。

### 2. `functions/src/flows/memoryAssistantFlow.ts`
**狙い**: RAG のパイプライン構築。
1.  ユーザーの質問を Embedding 化
2.  Retriever で関連日記を検索
3.  検索結果を Prompt に埋め込む（Context Injection）
4.  回答生成
この一連の流れをコードで表現します。

### 3. `functions/scripts/seedDiaries.ts`
**狙い**: Embedding の生成プロセス。データが保存されるタイミング（あるいはバッチ処理）でベクトル化が必要であることを、データ投入スクリプトを通じて理解します。

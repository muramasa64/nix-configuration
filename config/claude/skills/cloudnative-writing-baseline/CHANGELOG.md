# Changelog

All notable changes to `cloudnative-writing-baseline` are recorded here.

## 1.0.0 — 2026-08-17

Initial release candidate for organization-wide default deployment.

### Added

- CloudNative共通の日本語業務文書品質ベースラインを新設
- 事実性、確度保持、事実と推論の区別、因果関係に関する下限基準
- 媒体固有・職種固有・用途固有Skillとの優先順位規定
- 専用Skillを優先しつつ、事実性と意味保持は共通下限とする競合処理
- 新規文章作成時の外部検証可能な具体的事実に関する確度ルール
- 既存文章修正時の文体・敬語レベル保持
- 過剰修正を抑制する規定
- `license` およびガバナンス用 `metadata`
- READMEに出自、ライセンス、運用方針を記録

### Design decisions

旧来の執筆系Skillから、全社共通化に不向きな次の要素は採用していない。

- 一文一行などの組版規則
- 太字・脚注・コラム等の出版向け規則
- 未回収の緊張や問いかけを利用する物語的演出
- 特定職種・専門領域に依存する規則
- AIらしさ自体を評価目的とする規則
- Node等のコード実行依存
- 他Skillへの相対パス依存

### Optimization

初稿から重複規則を統合し、頻繁に利用されるデフォルトSkillとして本文を圧縮した。

descriptionについても、Skillルーティングに必要なpositive triggerとnegative triggerを残しつつ短縮した。

### Review disposition

- `SKILL.md` 1.2には確度を保持する書き換え例が3件、5.2には空虚になりやすい表現例が既にあるため、「具体例がない」という指摘による追記は行わない
- 完全な入力・出力例は、配布前評価で遵守上の不足が確認された場合に追加する
- 抽象規則の追加より、対象プラットフォームでの発火・非発火・専用Skill併用テストを優先する

### Compatibility clarification

初回配布前に、2026-08-17時点の一次情報を確認し、READMEの互換性情報をプラットフォーム別に更新した。未配布のためバージョンは1.0.0のままとする。

- Agent Skills仕様では、`description` は1〜1,024文字
- Claude Platform / APIでは、`description` は最大1,024文字でXMLタグを含めず、Skills APIへのアップロード、code execution、必要なbeta headerの設定が必要
- Claude.ai Custom Skillsでは、アップロードするSkillの `description` は最大200文字
- Claude Codeでは、Skill一覧に載せる `description` と `when_to_use` の合計は既定で最大1,536文字。Skill一覧全体の既定予算はコンテキストウィンドウの1%で、サイズ不明時のフォールバックは8,000文字
- 過去のClaude Codeに存在した250文字と2%という値は、現行の既定値として採用しない
- Claude.aiへの登録はユーザー個別であり、このZIPだけでは全社一括配布にならず、Claude Platform / APIやClaude Codeとも自動同期されない
- ChatGPT / Codexについて、単体SkillとOpenAI Pluginの配布単位を区別した
- Gleanについて、Agent Skills形式の直接インポートと、管理者設定・実環境検証を区別した
- Notion AIについて、Agent Skills ZIPの直接配布ではなく、個人またはCustom Agent固有のInstructions、もしくは共有可能なNotionページのSkillへ移植する方式であることを明記した
- 本Skillの `description` は136文字で、Agent Skillsとして直接取り込むことを確認した対象環境の個別上限に収まる
- 公式文書の単位表記は「characters」でありbyte上限ではないが、厳密なUnicodeカウント方式は明記されていないため、対象環境での受理確認を残す

READMEに一次情報へのリンクと、プラットフォーム別の配布前検証項目を追加した。`SKILL.md` の実行規則は変更していない。

### Pre-release review corrections — 2026-08-17

配布前の独立レビュー（作成者と別系統による審査。互換性主張を一次情報と突合）の結果、READMEを3点修正した。`SKILL.md` の実行規則は変更していない。未配布のためバージョンは1.0.0のままとする。

- Claude.aiの配布経路を訂正した。Team / EnterpriseではOwnerがOrganization settings > Skillsから組織全体に一括provisionでき、全メンバーに既定で有効となる（メンバーは個別オフのみ可・削除不可。一次情報: support.claude.com 記事13119606）。上記Compatibility clarificationの「Claude.aiへの登録はユーザー個別であり、このZIPだけでは全社一括配布にならず」という記述は個人プランに限る条件へ訂正し、全社配布の標準経路をOwnerによるprovisionとした。本節が同記述に優先する
- Claude Codeのフォールバック8,000文字について、「サイズ不明時」という発動条件が公式文書に明示されていないため条件の断定を削除した（出典はPrimary sources記載のenv-varsリファレンス）。本節が上記の同記述に優先する
- NotionのヘルプURLが404を返すため、現行ページ（notion.com/help/create-and-manage-skills）へ差し替えた（主張内容自体は現行ページで裏付けを確認済み）
- Primary sourcesに組織向けprovision記事を追加した

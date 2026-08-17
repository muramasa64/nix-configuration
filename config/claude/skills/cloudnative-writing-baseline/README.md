# cloudnative-writing-baseline

CloudNative Inc. が社内で利用する、日本語業務文書向けの共通品質ベースラインです。

## 目的

本Skillは、特定の文章スタイルや組版を強制するものではありません。

職種や媒体を問わず、次の最低品質を維持することを目的とします。

- 事実性
- 情報の確度
- 論理的一貫性
- 簡潔さ
- 自然な日本語
- 元情報および筆者意図の保持

媒体固有・職種固有・用途固有のSkillと併用することを前提としています。

## 配布方針

全社共通のデフォルトSkillとしての利用を想定しています。

本Skill自身は、外部スクリプト、コード実行、外部ファイル、兄弟Skillへの相対パス参照、特定LLM専用コマンドに依存しません。

## 出自

本Skillは CloudNative Inc. が社内利用を目的として新規作成したものです。

外部のSkill、Gist、テンプレート等をそのまま収録したものではありません。

既存の社内Skillを評価した際に得られた一般的な設計上の知見は参考にしていますが、本Skillの本文は社内向けに新規設計しています。

## License

Proprietary - CloudNative Inc. Internal Use Only

CloudNative Inc. の社内利用を前提とします。

社外への再配布、公開、ライセンス変更を行う場合は、別途権利関係と配布条件を確認してください。

## Version

Current version: 1.0.0

## Governance

Owner: CloudNative Inc.

Source classification: `internal-original`

Skillの変更はバージョン管理し、変更理由とレビュー結果をCHANGELOGまたはソース管理システムに記録します。

## Compatibility

2026-08-17時点の一次情報を確認した結果、`description` とSkill配布の制約はプラットフォームごとに異なります。いずれか一つの数値を全プラットフォーム共通の上限として扱いません。

本Skillの `description` は136文字です。

上記の `description` 上限を示す公式文書は、単位を「characters」と表記しており、byte上限とは記載していません。ただし、Unicode code point、grapheme cluster等の厳密な数え方は明示されていないため、136文字はUnicode code pointとしての計測値とし、最終的な受理可否は対象環境へのアップロードで確認します。

| 対象 | 確認した制約・配布方式 | 本パッケージの扱い |
| --- | --- | --- |
| Agent Skills仕様 | `description` は1〜1,024文字 | 適合 |
| Claude Platform / API | `description` は最大1,024文字で、XMLタグを含めない。利用にはSkills APIへのアップロード、code execution、必要なbeta headerの設定が必要 | 適合。APIへの登録と実行は導入環境で確認する |
| Claude.ai Custom Skills | アップロードするSkillの `description` は最大200文字。Skills機能の利用にはcode executionの有効化が必要 | 適合。Team / Enterpriseでは、OwnerがOrganization settings > Skillsから本ZIPをアップロードすることで組織全体に一括provisionでき、全メンバーに既定で有効となる（メンバーは個別オフのみ可・削除不可）。全社配布はこのOwnerによるprovisionを標準経路とする。個人プラン（Free / Pro / Max）では各ユーザーによる個別アップロードが必要。いずれの場合もClaude Platform / APIやClaude Codeとは自動同期されない |
| Claude Code | Skill一覧に載せる `description` と `when_to_use` の合計は既定で最大1,536文字。Skill一覧全体の既定予算はコンテキストウィンドウの1%で、フォールバックは8,000文字（8,000文字の出典はenv-varsリファレンス。フォールバックの発動条件は公式文書に明示されていない）。設定で変更可能 | 適合。共有予算は導入環境で再確認する |
| ChatGPT / Codex | `SKILL.md` の中核形式は利用できるが、このZIPは単体SkillでありOpenAI Pluginではない | Codexへの単体導入と、ChatGPTの組織配布・Web・モバイル利用を同一視しない。必要な場合はPluginとして別途パッケージ化・検証する |
| Glean | Agent Skills形式を採用し、`.zip`、`.md`、`.skill` を取り込める | 管理者設定、実環境へのインポート、明示・自動ルーティングを検証してから配布する |
| Notion AI | Notion SkillsはNotionページをSkillとして指定する方式であり、Agent Skills ZIPを直接配布する方式ではない | 常時適用する場合は個人のInstructionsへ移植するが、ページ共有だけでは他ユーザーへ自動適用されない。Custom AgentにはAgentごとのInstructionsが必要。共有可能なNotionページのSkillはオンデマンド利用とする |

`README.md` と `CHANGELOG.md` はガバナンス資料であり、実行時の外部依存ではありません。モデルが実行時に参照すべき規則は `SKILL.md` 内に自己完結しています。

### Primary sources

- [Agent Skills specification](https://agentskills.io/specification)
- [Claude Help: Skills overview](https://claude.com/docs/skills/overview)
- [Claude Help: Create and manage Skills](https://claude.com/docs/skills/how-to)
- [Claude Help: Provision and manage skills for your organization](https://support.claude.com/en/articles/13119606-provision-and-manage-skills-for-your-organization)
- [Claude Platform: Agent Skills overview](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview)
- [Claude Platform: Skills API guide](https://platform.claude.com/docs/en/build-with-claude/skills-guide)
- [Claude Code: Skill descriptions are cut short](https://code.claude.com/docs/en/skills#skill-descriptions-are-cut-short)
- [Claude Code settings](https://code.claude.com/docs/en/settings#available-settings)
- [Claude Code environment variables](https://code.claude.com/docs/en/env-vars)
- [OpenAI: Build skills](https://learn.chatgpt.com/docs/build-skills)
- [OpenAI: Build plugins](https://developers.openai.com/plugins/build/plugins)
- [Glean: Skills](https://docs.glean.com/user-guide/assistant/skills)
- [Notion: Create and manage skills](https://www.notion.com/help/create-and-manage-skills)
- [Notion: Instructions for Notion Agent](https://www.notion.com/help/instructions-for-notion-agent)

## Description budget policy

Skillのdescriptionはルーティングに利用され、インストールされているSkill群で共有されるコンテキスト予算にも影響します。

上限値や共有予算はプラットフォームと実行環境によって異なります。そのため、個々のSkillが単一プラットフォームの上限以内であることだけを基準とせず、ワークスペース全体で次を運用原則とします。

- descriptionには発火判断に必要な情報だけを書く
- positive triggerと重要なnegative triggerを優先する
- 本文で説明できる事項をdescriptionへ重複して書かない
- 新しいSkillを追加するときは、既存Skillとのルーティング競合も確認する

## Recommended validation

全社デフォルト配布前に、対象プラットフォームごとに少なくとも次を確認します。

1. YAML frontmatterとパッケージ構造が対象環境で受理されること
2. Claude Platform / APIではSkills APIへの登録、code execution、必要なbeta headerを設定し、実際のAPI呼び出しを確認すること
3. Claude.aiでは組織のcode execution設定を確認したうえで、Team / EnterpriseはOwnerが組織スキルとしてprovisionし（個人プランは各ユーザーがアップロードし）、非管理者アカウントで想定する業務文書に発火し、コード生成や創作では不要に発火しないこと
4. Claude CodeではSkill一覧への掲載と、明示・自動起動が期待どおりであること
5. ChatGPT / Codexでは単体SkillまたはPluginのどちらで配布するかを決め、対象クライアントで導入・起動を確認すること
6. Gleanでは管理者設定、ZIPインポート、明示・自動ルーティングを実環境で確認すること
7. Notion AIでは用途に応じて個人のInstructions、Custom Agent固有のInstructions、または共有可能なNotionページのSkillへ移植し、対象ユーザーへの適用範囲を確認すること
8. 提案書、報告、議事録、メール、Slack下書きなどの実例で、事実性、確度、論理、簡潔さを評価すること
9. 媒体固有Skillやhumanize-review等と併用しても、書式を奪わず、事実性・確度保持の下限基準が維持されること

これらの対象環境での検証が完了するまでは、「全社デフォルト配布完了」とは扱いません。

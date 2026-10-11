# מדריך התקנה – Claude Agent Kit

הקיט מוסיף ל-Claude Code חמישה סוכני-משנה (`scout`, `planner`, `coder`,
`reviewer`, `archivist`) וגם כללי ניתוב שנכתבים ל-`~/.claude/CLAUDE.md`. הכללים
אומרים לסשן הראשי מתי להעביר עבודה לכל סוכן, כדי לחסוך בטוקנים.

יש שתי דרכים להתקין:

- **[ענן](#אפשרות-א--ענן-claude-code-on-the-web)**: Claude Code on the web (claude.ai/code), כולל האפליקציה בנייד ובדסקטופ כשהסשן רץ בענן.
- **[לוקלי](#אפשרות-ב--לוקלי-cli--ide--דסקטופ)**: ה-CLI, תוסף ה-IDE או אפליקציית הדסקטופ שרצים על המחשב שלך.

---

## אפשרות א' – ענן (Claude Code on the web)

בענן כל סשן מתחיל בקונטיינר חדש ונקי, ולכן התקנה ידנית חד-פעמית לא נשמרת.
במקום זה מוסיפים שורה ל-**Setup script** של הסביבה, והיא רצה בתחילת כל סשן.

### דרישות

- חשבון Claude עם גישה ל-Claude Code on the web.
- מדיניות הרשת של הסביבה צריכה לאפשר גישה ל-`github.com`. ברירת המחדל (Trusted)
  מאפשרת אותה.

### שלבים

1. פותחים את https://claude.ai/code.
2. פותחים את תפריט הסביבה (environment) בשורת הכותרת של הסשן ולוחצים **Edit**.
   אפשר גם ליצור סביבה חדשה.
3. בשדה **Setup script** מדביקים את השורה:

   ```bash
   git clone --depth 1 -b master https://github.com/Marku-a/claude-agents /tmp/claude-kit && bash /tmp/claude-kit/install.sh || true
   ```

4. שומרים ופותחים **סשן חדש**. הסקריפט רץ רק בסשנים שנפתחים אחרי השמירה.

מה כל חלק בשורה עושה:

- `-b master` מוריד את הענף `master`, לא משנה איזה ענף מוגדר כברירת המחדל במאגר.
- `|| true` מבטיח שהסשן יעלה גם אם ההורדה או ההתקנה נכשלו (למשל בגלל תקלת רשת).
  במקרה כזה הסוכנים פשוט לא יותקנו.

### איך בודקים שזה עבד

בסשן החדש שואלים: **"what agents are available?"**. ברשימה צריכים להופיע
`scout`, `planner`, `coder`, `reviewer` ו-`archivist`.

אם הם לא מופיעים:

- בודקים שהשורה נשמרה ב-Setup script של אותה סביבה שבה הסשן רץ.
- בודקים שמדיניות הרשת לא חוסמת את `github.com`.
- מוחקים זמנית את `|| true`, פותחים סשן חדש ורואים איזו שגיאה מתקבלת.

### עדכון

אין צורך לעשות כלום: כל סשן חדש מוריד את הגרסה העדכנית מ-`master`.

### הסרה

מוחקים את השורה מה-Setup script. סשנים חדשים יעלו בלי הקיט.

---

## אפשרות ב' – לוקלי (CLI / IDE / דסקטופ)

ההתקנה הלוקלית היא אותו קיט עם הבדל אחד: `archivist` קורא את התמלילים של
הסשנים המקומיים שלך מ-`~/.claude/projects/`, ולא את שרת ה-MCP
`claude-code-remote`, שקיים רק בענן.

### דרישות

- [Claude Code](https://code.claude.com/docs) מותקן ומחובר לחשבון.
- `git` ו-`bash`:
  - **macOS / Linux:** כבר מותקנים.
  - **Windows:** מתקינים [Git for Windows](https://git-scm.com/download/win), שכולל
    את Git Bash. מריצים את הפקודות שבהמשך ב-**Git Bash**, לא ב-PowerShell ולא
    ב-cmd. אפשר גם להשתמש ב-WSL אם Claude Code רץ בתוך WSL.

### התקנה

```bash
git clone -b master https://github.com/Marku-a/claude-agents ~/claude-agents
bash ~/claude-agents/install.sh --local
```

הפקודות כותבות:

- את `~/.claude/agents/{scout,planner,coder,reviewer,archivist}.md`.
- את כללי הניתוב לתוך `~/.claude/CLAUDE.md`, בין הסימונים
  `<!-- claude-agent-kit:routing -->` ו-`<!-- /claude-agent-kit:routing -->`.
  אם כבר יש לך `CLAUDE.md`, הקיט מוסיף את הקטע שלו והתוכן הקיים שלך נשמר. כשהתקנה
  מאוחרת יותר מחליפה את הקטע, הקובץ הקודם נשמר כגיבוי ב-`~/.claude/CLAUDE.md.bak`.

אחרי ההתקנה מפעילים מחדש כל סשן Claude Code שרץ, כדי שיטען את הסוכנים.

### איך בודקים שזה עבד

בסשן חדש מריצים `/agents`, או שואלים "what agents are available?". צריכים
להופיע חמשת הסוכנים.

### עדכון

```bash
git -C ~/claude-agents pull
bash ~/claude-agents/install.sh --local
```

הסוכנים נדרסים בגרסה החדשה, וקטע הקיט ב-`CLAUDE.md` מוחלף. תוכן מחוץ לסימונים
נשמר. אפשר להריץ את ההתקנה כמה פעמים שרוצים, ריצה חוזרת לא משנה כלום.

### הסרה

```bash
bash ~/claude-agents/install.sh --uninstall
```

הפקודה מוחקת את חמשת הסוכנים של הקיט ואת קטע הקיט מ-`CLAUDE.md` (עם גיבוי
ב-`CLAUDE.md.bak`). התוכן שלך וסוכנים אחרים לא נוגעים בהם. אחר כך אפשר למחוק את
התיקייה `~/claude-agents`.

### לנסות בלי לגעת בהגדרות שלך

```bash
HOME=$(mktemp -d) bash ~/claude-agents/install.sh --local
```

ההתקנה נכתבת לתיקייה זמנית, כך שאפשר לראות מה היא עושה בלי לשנות את `~/.claude`.

---

## הערות לשתי האפשרויות

- **התאמה אישית.** לא עורכים בתוך הסימונים ב-`CLAUDE.md` ולא את קבצי הסוכנים
  המותקנים, כי ההתקנה הבאה דורסת אותם. כללים משלך כותבים מחוץ לסימונים. לשינויים
  גדולים עושים fork למאגר ומתקינים ממנו (בענן מחליפים את ה-URL בשורת ה-Setup script).
- **גישה למודלים.** `planner` ו-`reviewer` משתמשים ב-`opus`, `coder` ב-`sonnet`,
  ו-`scout` ו-`archivist` ב-`haiku`. אם התוכנית שלך לא כוללת אחד מהם, משנים את שורת
  `model:` שלו ב-fork, או כותבים בה `inherit`.
- **היסטוריה ל-archivist (לוקלי).** Claude Code מוחק תמלילים מקומיים שישנים
  מ-`cleanupPeriodDays` (ברירת מחדל: 30 יום). כדי ש-archivist יגיע אחורה יותר, מגדילים
  את הערך ב-`~/.claude/settings.json`.

למידע נוסף על הסוכנים ועל כללי הניתוב, ראו [README.md](README.md).

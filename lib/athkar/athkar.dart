// final List<Athkar> athkars = [
//   Athkar(
//       paragraph:
//           "«أَصْبَحْنا وَأَصْبَحَ المُلْكُ لله، وَالحَمدُ لله، لا إلهَ إلاّ الله وَحدَهُ لا شَريكَ لهُ، لهُ المُلكُ، ولهُ الحَمْد، وهُوَ على كلّ شَيءٍ قدير، رَبِّ أسْأَلُكَ خَيرَ ما في هذا اليوم، وَخَيرَ ما بَعْدَه، وَأَعوذُ بِكَ مِنْ شَرِّ ما في هذا اليوم، وَشَرِّ ما بَعْدَه، رَبِّ أَعوذُ بِكَ مِنَ الْكَسَلِ، وَسوءِ الْكِبَر، رَبِّ أَعوذُ بِكَ مِنْ عَذابٍ في النّارِ، وَعَذابٍ في القَبْر»",
//       counter: 5),
//   Athkar(paragraph: "Paragraph 2", counter: 4),
//   Athkar(paragraph: "Paragraph 3", counter: 3),
//   Athkar(paragraph: "Paragraph 4", counter: 2),
// ];

class Athkar {
  final String paragraph;
  int counter;

  Athkar({required this.paragraph, required this.counter});
}

final List<int> counters = [
  1,
  3,
  3,
  3,
  1,
  1,
  3,
  4,
  1,
  7,
  3,
  1,
  1,
  3,
  3,
  3,
  1,
  3,
  1,
  1,
  3,
  10,
  3,
  3,
  3,
  3,
  10,
  1,
  100,
];

//final List<Athkar> athkars = [];

List paragraphsMorning = [
  {
    "paragraph":
        "الله لا إله إلا هو الحي القيوم لا تأخذه سنة ولا نوم له ما في السموات وما في الأرض من ذا الذي يشفع عنده إلا بإذنه يعلم ما بين أيديهم وما خلفهم ولا يحيطون بشيء من علمه إلا بما شاء وسع كرسيه السموات والأرض ولا يؤوده حفظهما وهو العلي العظيم",
    "Counter": 1
  },
  {
    "paragraph":
        "بسم الله الرحمن الرحيم ﴿قل هو الله أحد* الله الصمد* لم يلد ولم يولد* ولم يكن له كفوا أحد﴾",
    "Counter": 3
  },
  {
    "paragraph":
        "بسم الله الرحمن الرحيم ﴿قل أعوذ برب الفلق* من شر ما خلق* ومن شر غاسق إذا وقب* ومن شر النفاثات في العقد* ومن شر حاسد إذا حسد﴾",
    "Counter": 3
  },
  {
    "paragraph":
        "بسم الله الرحمن الرحيم ﴿قل أعوذ برب الناس* ملك الناس* إله الناس* من شر الوسواس الخناس* الذي يوسوس في صدور الناس* من الجنة و الناس﴾",
    "Counter": 3
  },
  {
    "paragraph":
        "أصبحنا وأصبح الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير، رب أسألك خير ما في هذا اليوم وخير ما بعده، وأعوذ بك من شر ما في هذا اليوم وشر ما بعده، رب أعوذ بك من الكسل وسوء الكبر، رب أعوذ بك من عذاب في النار وعذاب في القبر",
    "Counter": 1
  },
  {
    "paragraph":
        "اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
    "Counter": 1
  },
  {
    "paragraph":
        "رضيت بالله ربا، وبالإسلام دينا، وبمحمد صلى الله عليه وسلم نبيا ورسولا",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم إني أصبحت أشهدك، وأشهد حملة عرشك، وملائكتك، وجميع خلقك، أنك أنت الله لا إله إلا أنت وحدك لا شريك لك، وأن محمدا عبدك ورسولك",
    "Counter": 4
  },
  {
    "paragraph":
        "اللهم ما أصبح بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك، فلك الحمد ولك الشكر",
    "Counter": 1
  },
  {
    "paragraph": "حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم",
    "Counter": 7
  },
  {
    "paragraph":
        "بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم",
    "Counter": 3
  },
  {
    "paragraph": "اللهم بك أصبحنا، وبك أمسينا، وبك نحيا، وبك نموت وإليك النشور",
    "Counter": 1
  },
  {
    "paragraph":
        "أصبحنا على فطرة الإسلام، وعلى كلمة الإخلاص، وعلى دين نبينا محمد صلى الله عليه وسلم، وعلى ملة أبينا إبراهيم، حنيفا مسلما وما كان من المشركين",
    "Counter": 1
  },
  {
    "paragraph":
        "سبحان الله وبحمده عدد خلقه، ورضا نفسه، وزنة عرشه، ومداد كلماته",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم عافني في بدني، اللهم عافني في سمعي، اللهم عافني في بصري، لا إله إلا أنت",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم إني أعوذ بك من الكفر، والفقر، وأعوذ بك من عذاب القبر، لا إله إلا أنت",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم إني أسألك العفو والعافية في الدنيا والآخرة، اللهم إني أسألك العفو والعافية في ديني ودنياي وأهلي، ومالي، اللهم استر عوراتي، وآمن روعاتي، اللهم احفظني من بين يدي، ومن خلفي، وعن يميني، وعن شمالي، ومن فوقي، وأعوذ بعظمتك أن أغتال من تحتي",
    "Counter": 1
  },
  {
    "paragraph":
        "يا حي يا قيوم برحمتك أستغيث أصلح لي شأني كله ولا تكلني إلى نفسي طرفة عين",
    "Counter": 3
  },
  {
    "paragraph":
        "أصبحنا وأصبح الملك لله رب العالمين، اللهم إني أسألك خير هذا اليوم فتحه، ونصره، ونوره، وبركته، وهداه، وأعوذ بك من شر ما فيه وشر ما بعده",
    "Counter": 1
  },
  {
    "paragraph":
        "اللهم عالم الغيب والشهادة فاطر السموات والأرض، رب كل شيء ومليكه، أشهد أن لا إله إلا أنت، أعوذ بك من شر نفسي، ومن شر الشيطان وشركه، وأن أقترف على نفسي سوءا، أو أجره إلى مسلم",
    "Counter": 1
  },
  {"paragraph": "أعوذ بكلمات الله التامات من شر ما خلق", "Counter": 3},
  {"paragraph": "اللهم صل وسلم على نبينا محمد", "Counter": 10},
  {
    "paragraph":
        "اللهم إني أعوذ بك من أن أشرك بك شيئا أعلمه، وأستغفرك لما لا أعلمه",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم إني أعوذ بك من الهم والحزن، وأعوذ بك من العجز والكسل، وأعوذ بك الجبن والبخل، وأعوذ بك من غلبة الدين وقهر الرجال",
    "Counter": 3
  },
  {
    "paragraph":
        "أستغفر الله العظيم الذي لا إله إلا هو، الحي القيوم وأتوب إليه",
    "Counter": 3
  },
  {
    "paragraph": "يا رب لك الحمد كما ينبغي لجلال وجهك، ولعظيم سلطانك",
    "Counter": 3
  },
  {
    "paragraph":
        "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير",
    "Counter": 10
  },
  {
    "paragraph":
        "اللهم أنت ربي لا إله إلا أنت، عليك توكلت، وأنت رب العرش العظيم، ما شاء الله كان، وما لم يشأ لم يكن، ولا حول ولا قوة إلا بالله العلي العظيم، أعلم أن الله على كل شيء قدير، وأن الله قد أحاط بكل شيء علمًا، اللهم إني أعوذ بك من شر نفسي، ومن شر كل دابة أنت آخذ بناصيتها، إن ربي على صراط مستقيم",
    "Counter": 1
  },
  {"paragraph": "سبحان الله وبحمده", "Counter": 100},
];

List paragraphsEvening = [
  {
    "paragraph":
        "الله لا إله إلا هو الحي القيوم لا تأخذه سنة ولا نوم له ما في السموات وما في الأرض من ذا الذي يشفع عنده إلا بإذنه يعلم ما بين أيديهم وما خلفهم ولا يحيطون بشيء من علمه إلا بما شاء وسع كرسيه السموات والأرض ولا يؤوده حفظهما وهو العلي العظيم",
    "Counter": 1
  },
  {
    "paragraph":
        "آمن الرسول بما أنزل إليه من ربه والمؤمنون كل آمن بالله وملآئكته وكتبه ورسله لا نفرق بين أحد من رسله وقالوا سمعنا وأطعنا غفرانك ربنا وإليك المصير* لا يكلف الله نفسا إلا وسعها لها ما كسبت وعليها ما اكتسبت ربنا لا تؤاخذنا إن نسينا أو أخطأنا ربنا ولا تحمل علينا إصرا كما حملته على الذين من قبلنا ربنا ولا تحملنا ما لا طاقة لنا به واعف عنا واغفر لنا وارحمنآ أنت مولانا فانصرنا على القوم الكافرين",
    "Counter": 1
  },
  {
    "paragraph":
        "بسم الله الرحمن الرحيم ﴿قل هو الله أحد* الله الصمد* لم يلد ولم يولد* ولم يكن له كفوا أحد﴾",
    "Counter": 3
  },
  {
    "paragraph":
        "بسم الله الرحمن الرحيم ﴿قل أعوذ برب الفلق* من شر ما خلق* ومن شر غاسق إذا وقب* ومن شر النفاثات في العقد* ومن شر حاسد إذا حسد﴾",
    "Counter": 3
  },
  {
    "paragraph":
        "بسم الله الرحمن الرحيم ﴿قل أعوذ برب الناس* ملك الناس* إله الناس* من شر الوسواس الخناس* الذي يوسوس في صدور الناس* من الجنة و الناس﴾",
    "Counter": 3
  },
  {
    "paragraph":
        "أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير، رب أسألك خير ما في هذه الليلة وخير ما بعدها، وأعوذ بك من شر ما في هذه الليلة وشر ما بعدها، رب أعوذ بك من الكسل وسوء الكبر، رب أعوذ بك من عذاب في النار وعذاب في القبر",
    "Counter": 1
  },
  {
    "paragraph":
        "اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",
    "Counter": 1
  },
  {
    "paragraph":
        "رضيت بالله ربا، وبالإسلام دينا، وبمحمد صلى الله عليه وسلم نبيا ورسولا",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم إني أمسيت أشهدك، وأشهد حملة عرشك، وملائكتك، وجميع خلقك، أنك أنت الله لا إله إلا أنت وحدك لا شريك لك، وأن محمدا عبدك ورسولك",
    "Counter": 4
  },
  {
    "paragraph":
        "اللهم ما أمسى بي من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك، فلك الحمد ولك الشكر",
    "Counter": 1
  },
  {
    "paragraph": "حسبي الله لا إله إلا هو عليه توكلت وهو رب العرش العظيم",
    "Counter": 7
  },
  {
    "paragraph":
        "بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم",
    "Counter": 3
  },
  {
    "paragraph": "اللهم بك أمسينا، وبك أصبحنا، وبك نحيا، وبك نموت وإليك المصير",
    "Counter": 1
  },
  {
    "paragraph":
        "أمسينا على فطرة الإسلام، وعلى كلمة الإخلاص، وعلى دين نبينا محمد صلى الله عليه وسلم، وعلى ملة أبينا إبراهيم، حنيفا مسلما وما كان من المشركين",
    "Counter": 1
  },
  {
    "paragraph":
        "سبحان الله وبحمده عدد خلقه، ورضا نفسه، وزنة عرشه، ومداد كلماته",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم عافني في بدني، اللهم عافني في سمعي، اللهم عافني في بصري، لا إله إلا أنت",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم إني أعوذ بك من الكفر، والفقر، وأعوذ بك من عذاب القبر، لا إله إلا أنت",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم إني أسألك العفو والعافية في الدنيا والآخرة، اللهم إني أسألك العفو والعافية في ديني ودنياي وأهلي، ومالي، اللهم استر عوراتي، وآمن روعاتي، اللهم احفظني من بين يدي، ومن خلفي، وعن يميني، وعن شمالي، ومن فوقي، وأعوذ بعظمتك أن أغتال من تحتي",
    "Counter": 1
  },
  {
    "paragraph":
        "يا حي يا قيوم برحمتك أستغيث أصلح لي شأني كله ولا تكلني إلى نفسي طرفة عين",
    "Counter": 3
  },
  {
    "paragraph":
        "أمسينا وأمسى الملك لله رب العالمين، اللهم إني أسألك خير هذه الليلة فتحها، ونصرها، ونورها، وبركتها، وهداها، وأعوذ بك من شر ما فيها وشر ما بعدها",
    "Counter": 1
  },
  {
    "paragraph":
        "اللهم عالم الغيب والشهادة فاطر السموات والأرض، رب كل شيء ومليكه، أشهد أن لا إله إلا أنت، أعوذ بك من شر نفسي، ومن شر الشيطان وشركه، وأن أقترف على نفسي سوءا، أو أجره إلى مسلم",
    "Counter": 1
  },
  {"paragraph": "أعوذ بكلمات الله التامات من شر ما خلق", "Counter": 3},
  {"paragraph": "اللهم صل وسلم على نبينا محمد", "Counter": 10},
  {
    "paragraph":
        "اللهم إني أعوذ بك من أن أشرك بك شيئا أعلمه، وأستغفرك لما لا أعلمه",
    "Counter": 3
  },
  {
    "paragraph":
        "اللهم إني أعوذ بك من الهم والحزن، وأعوذ بك من العجز والكسل، وأعوذ بك الجبن والبخل، وأعوذ بك من غلبة الدين وقهر الرجال",
    "Counter": 3
  },
  {
    "paragraph":
        "أستغفر الله العظيم الذي لا إله إلا هو، الحي القيوم وأتوب إليه",
    "Counter": 3
  },
  {
    "paragraph": "يا رب لك الحمد كما ينبغي لجلال وجهك، ولعظيم سلطانك",
    "Counter": 3
  },
  {
    "paragraph":
        "لا إله إلا الله وحده لا شريك له، له الملك وله الحمد، وهو على كل شيء قدير",
    "Counter": 10
  },
  {
    "paragraph":
        "اللهم أنت ربي لا إله إلا أنت، عليك توكلت، وأنت رب العرش العظيم، ما شاء الله كان، وما لم يشأ لم يكن، ولا حول ولا قوة إلا بالله العلي العظيم، أعلم أن الله على كل شيء قدير، وأن الله قد أحاط بكل شيء علمًا، اللهم إني أعوذ بك من شر نفسي، ومن شر كل دابة أنت آخذ بناصيتها، إن ربي على صراط مستقيم",
    "Counter": 1
  },
  {"paragraph": "سبحان الله وبحمده", "Counter": 100},
];

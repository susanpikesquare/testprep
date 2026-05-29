import Foundation

enum SampleQuestionBank {
    static let dailyPractice: [PracticeQuestion] = [
        readingMainIdeaL2,
        readingDetailL2,
        readingInferenceL3,
        readingPurposeL4,
        readingWorkplaceL3,
        mathFractionsL2,
        mathPercentL2,
        mathEquationL3,
        mathRentalEquationL4,
        mathMeanL3,
        scienceVariableL4,
        scienceGraphL3,
        scienceEcosystemL2,
        socialBranchesL1,
        socialChecksL4,
        socialMapL2,
        writingAgreementL1,
        writingRevisionL4
    ]

    static var todaySession: [PracticeQuestion] {
        Array(dailyPractice.prefix(5))
    }

    static let readingQuest: [PracticeQuestion] = [
        readingMainIdeaL2,
        readingDetailL2,
        readingInferenceL3,
        readingPurposeL4,
        readingWorkplaceL3
    ]

    static let writingQuest: [PracticeQuestion] = [
        writingAgreementL1,
        writingCommaL2,
        writingRevisionL4,
        writingOrganizationL3,
        writingEssayPlanL4
    ]

    static let mathQuest: [PracticeQuestion] = [
        mathFractionsL2,
        mathPercentL2,
        mathEquationL3,
        mathRentalEquationL4,
        mathMeanL3
    ]

    static let scienceQuest: [PracticeQuestion] = [
        scienceVariableL4,
        scienceGraphL3,
        scienceEcosystemL2,
        scienceMatterL1,
        scienceForcesL3
    ]

    static let socialStudiesRescue: [PracticeQuestion] = [
        socialBranchesL1,
        socialMapL2,
        socialSupplyDemandL2,
        socialFoundingL3,
        socialChecksL4
    ]

    static var allSessions: [PracticeSession] {
        [
            PracticeSession(
                title: "Daily HiSET mix",
                subtitle: "18 questions across all subjects",
                iconName: "sun.max.fill",
                estimatedMinutes: 15,
                questions: dailyPractice
            ),
            PracticeSession(
                title: "Social Studies rescue",
                subtitle: "Government, maps, economics",
                iconName: "target",
                estimatedMinutes: 6,
                questions: socialStudiesRescue
            ),
            PracticeSession(
                title: "Reading clues",
                subtitle: "Main idea, inference, purpose",
                iconName: "text.book.closed.fill",
                estimatedMinutes: 6,
                questions: readingQuest
            ),
            PracticeSession(
                title: "Math builder",
                subtitle: "Fractions, percent, equations",
                iconName: "number.circle.fill",
                estimatedMinutes: 7,
                questions: mathQuest
            ),
            PracticeSession(
                title: "Science data lab",
                subtitle: "Variables, graphs, evidence",
                iconName: "atom",
                estimatedMinutes: 6,
                questions: scienceQuest
            ),
            PracticeSession(
                title: "Writing tune-up",
                subtitle: "Grammar, revision, essay planning",
                iconName: "pencil.and.scribble",
                estimatedMinutes: 6,
                questions: writingQuest
            )
        ]
    }
}

private extension SampleQuestionBank {
    static let readingMainIdeaL2 = PracticeQuestion(
        id: "reading-main-idea-l2-001",
        subject: .reading,
        skill: "Main Idea",
        difficulty: .fundamentals,
        prompt: "A short article explains that community gardens give neighbors fresh food, outdoor activity, and a place to work together. What is the main idea?",
        choices: [
            "Community gardens can help neighborhoods in several ways.",
            "Fresh food is always expensive.",
            "Outdoor work is only useful in summer.",
            "Neighbors should avoid shared projects."
        ],
        correctChoiceIndex: 0,
        explanation: "The correct answer covers all three benefits from the article instead of focusing on just one detail.",
        encouragement: "Main idea questions ask for the big picture. You found the umbrella idea."
    )

    static let readingDetailL2 = PracticeQuestion(
        id: "reading-detail-l2-001",
        subject: .reading,
        skill: "Supporting Details",
        difficulty: .fundamentals,
        prompt: "A workplace notice says employees must submit schedule requests by Friday at 3 p.m. When are requests due?",
        choices: ["Monday morning", "Thursday at noon", "Friday at 3 p.m.", "Any time next week"],
        correctChoiceIndex: 2,
        explanation: "This is a detail question. The due time is stated directly in the notice.",
        encouragement: "Details are find-the-clue questions. No trick needed."
    )

    static let readingInferenceL3 = PracticeQuestion(
        id: "reading-inference-l3-001",
        subject: .reading,
        skill: "Inference",
        difficulty: .highSchool,
        prompt: "After reading the job posting twice, Lena highlighted the required skills and updated her resume. What can you infer?",
        choices: [
            "Lena is preparing to apply for the job.",
            "Lena already works for the company.",
            "Lena dislikes reading job postings.",
            "Lena has decided not to work."
        ],
        correctChoiceIndex: 0,
        explanation: "The clues show Lena is using the posting to prepare her resume, which points to applying.",
        encouragement: "Inference means using clues, not guessing from nowhere."
    )

    static let readingPurposeL4 = PracticeQuestion(
        id: "reading-purpose-l4-001",
        subject: .reading,
        skill: "Author's Purpose",
        difficulty: .hisetReady,
        prompt: "A passage describes both supporters and critics of a plan to add bus routes. Supporters mention easier commuting, while critics mention cost. What is the author's main purpose?",
        choices: [
            "To argue that buses should be banned",
            "To present different views on a public plan",
            "To explain how bus engines work",
            "To criticize everyone who uses public transportation"
        ],
        correctChoiceIndex: 1,
        explanation: "The author gives both sides of the issue, so the purpose is to present different viewpoints.",
        encouragement: "HiSET reading often asks why the author wrote the passage. Look at the job the whole passage is doing."
    )

    static let readingWorkplaceL3 = PracticeQuestion(
        id: "reading-workplace-l3-001",
        subject: .reading,
        skill: "Workplace Documents",
        difficulty: .highSchool,
        prompt: "A safety memo says, 'Report spills immediately so the area can be marked and cleaned.' What should a worker do first after noticing a spill?",
        choices: ["Leave the spill alone", "Report the spill", "Move a machine over it", "Wait until the end of the shift"],
        correctChoiceIndex: 1,
        explanation: "The memo says to report spills immediately. That makes reporting the first step.",
        encouragement: "Workplace document questions reward careful reading of instructions."
    )

    static let writingAgreementL1 = PracticeQuestion(
        id: "writing-agreement-l1-001",
        subject: .writing,
        skill: "Grammar",
        difficulty: .foundation,
        prompt: "Choose the correct sentence.",
        choices: [
            "They was late.",
            "They were late.",
            "They be late.",
            "They is late."
        ],
        correctChoiceIndex: 1,
        explanation: "They pairs with were: They were late.",
        encouragement: "Grammar gets easier when you listen for the sentence that sounds complete and standard."
    )

    static let writingCommaL2 = PracticeQuestion(
        id: "writing-comma-l2-001",
        subject: .writing,
        skill: "Punctuation",
        difficulty: .fundamentals,
        prompt: "Which sentence uses the comma correctly?",
        choices: [
            "After work Maria studied math.",
            "After work, Maria studied math.",
            "After, work Maria studied math.",
            "After work Maria, studied math."
        ],
        correctChoiceIndex: 1,
        explanation: "A comma after the opening phrase helps the sentence read clearly.",
        encouragement: "Punctuation is a road sign. It tells the reader where to pause."
    )

    static let writingRevisionL4 = PracticeQuestion(
        id: "writing-revision-l4-001",
        subject: .writing,
        skill: "Revision",
        difficulty: .hisetReady,
        prompt: "Choose the best revision: 'The store closed early. The power went out.'",
        choices: [
            "The store closed early because the power went out.",
            "The store closed early the power went out.",
            "The power went out the store closed early.",
            "Closed early the store because power."
        ],
        correctChoiceIndex: 0,
        explanation: "Because clearly shows the cause-and-effect relationship between the power outage and the closing.",
        encouragement: "Good revision often connects ideas so the reader does less work."
    )

    static let writingOrganizationL3 = PracticeQuestion(
        id: "writing-organization-l3-001",
        subject: .writing,
        skill: "Organization",
        difficulty: .highSchool,
        prompt: "A paragraph begins with a topic sentence about saving money. Which detail best belongs in that paragraph?",
        choices: [
            "Setting aside ten dollars each week can build an emergency fund.",
            "Many people enjoy watching movies.",
            "Weather changes quickly in spring.",
            "Some cars are painted blue."
        ],
        correctChoiceIndex: 0,
        explanation: "The correct detail supports the topic of saving money.",
        encouragement: "Organization questions are about what belongs together."
    )

    static let writingEssayPlanL4 = PracticeQuestion(
        id: "writing-essay-l4-001",
        subject: .writing,
        skill: "Essay Basics",
        difficulty: .hisetReady,
        prompt: "Which is the strongest thesis for an essay about whether experience or education matters more at work?",
        choices: [
            "Jobs are things people have.",
            "Both are good sometimes.",
            "Experience is more useful for workplace success because it builds problem-solving, confidence, and practical judgment.",
            "Education happens in schools."
        ],
        correctChoiceIndex: 2,
        explanation: "The strongest thesis takes a clear position and gives reasons that can become body paragraphs.",
        encouragement: "A thesis is your essay's steering wheel. It points the whole answer."
    )

    static let mathFractionsL2 = PracticeQuestion(
        id: "math-fractions-l2-001",
        subject: .math,
        skill: "Fractions",
        difficulty: .fundamentals,
        prompt: "Which fraction is equal to 3/4?",
        choices: ["3/8", "6/8", "4/6", "6/12"],
        correctChoiceIndex: 1,
        explanation: "3/4 becomes 6/8 when you multiply the top and bottom by 2.",
        encouragement: "Equivalent fractions are the same amount wearing different numbers."
    )

    static let mathPercentL2 = PracticeQuestion(
        id: "math-percent-l2-001",
        subject: .math,
        skill: "Percentages",
        difficulty: .fundamentals,
        prompt: "A jacket costs $40 and is 25% off. How much is the discount?",
        choices: ["$5", "$10", "$15", "$25"],
        correctChoiceIndex: 1,
        explanation: "25% is one fourth. One fourth of $40 is $10.",
        encouragement: "Percent questions often become easier when you turn the percent into a familiar fraction."
    )

    static let mathEquationL3 = PracticeQuestion(
        id: "math-equation-l3-001",
        subject: .math,
        skill: "Solving Equations",
        difficulty: .highSchool,
        prompt: "Solve for x: 3x + 4 = 19",
        choices: ["3", "5", "7", "15"],
        correctChoiceIndex: 1,
        explanation: "Subtract 4 to get 3x = 15. Divide by 3 to get x = 5.",
        encouragement: "Two-step equations are balance puzzles. Undo one move at a time."
    )

    static let mathRentalEquationL4 = PracticeQuestion(
        id: "math-equation-l4-001",
        subject: .math,
        skill: "Expressions",
        difficulty: .hisetReady,
        prompt: "A repair service charges a $45 visit fee plus $30 per hour. Which expression shows the cost for h hours?",
        choices: ["45h + 30", "45 + 30h", "30 + 45h", "75h"],
        correctChoiceIndex: 1,
        explanation: "The fixed fee is 45, and 30 is multiplied by the number of hours, h.",
        encouragement: "HiSET math often asks you to translate words into an expression."
    )

    static let mathMeanL3 = PracticeQuestion(
        id: "math-mean-l3-001",
        subject: .math,
        skill: "Mean",
        difficulty: .highSchool,
        prompt: "What is the mean of 6, 8, 10, and 12?",
        choices: ["8", "9", "10", "12"],
        correctChoiceIndex: 1,
        explanation: "Add the numbers to get 36. Divide by 4 numbers to get 9.",
        encouragement: "Mean means balance point: total divided by how many numbers."
    )

    static let scienceMatterL1 = PracticeQuestion(
        id: "science-matter-l1-001",
        subject: .science,
        skill: "Matter",
        difficulty: .foundation,
        prompt: "Water turning into ice is an example of which change?",
        choices: ["Freezing", "Burning", "Rusting", "Evaporating"],
        correctChoiceIndex: 0,
        explanation: "Liquid water becomes solid ice when it freezes.",
        encouragement: "Science words often name changes you already recognize."
    )

    static let scienceEcosystemL2 = PracticeQuestion(
        id: "science-ecosystem-l2-001",
        subject: .science,
        skill: "Ecosystems",
        difficulty: .fundamentals,
        prompt: "If a drought reduces the number of plants in an area, what might happen to animals that eat those plants?",
        choices: [
            "They may have less food.",
            "They will need no food.",
            "They will all become plants.",
            "They will stop needing water."
        ],
        correctChoiceIndex: 0,
        explanation: "Animals that depend on plants can be affected when fewer plants are available.",
        encouragement: "Ecosystem questions are connection questions."
    )

    static let scienceGraphL3 = PracticeQuestion(
        id: "science-graph-l3-001",
        subject: .science,
        skill: "Graph Reading",
        difficulty: .highSchool,
        prompt: "A line graph shows a car's speed increasing from 20 mph to 50 mph over five minutes. What trend does the graph show?",
        choices: ["Speed decreases", "Speed increases", "Speed stays the same", "Speed cannot be measured"],
        correctChoiceIndex: 1,
        explanation: "The values go up over time, so the trend is increasing speed.",
        encouragement: "Before reading every detail, ask what direction the graph is moving."
    )

    static let scienceVariableL4 = PracticeQuestion(
        id: "science-variable-l4-001",
        subject: .science,
        skill: "Variables",
        difficulty: .hisetReady,
        prompt: "Students test whether different amounts of water affect bean plant growth. Which factor should they keep the same for every plant?",
        choices: ["Amount of water", "Type of plant", "Final height", "Conclusion"],
        correctChoiceIndex: 1,
        explanation: "The amount of water is what they are testing, so the plant type should stay the same to make the test fair.",
        encouragement: "In experiment questions, keep everything the same except what is being tested."
    )

    static let scienceForcesL3 = PracticeQuestion(
        id: "science-force-l3-001",
        subject: .science,
        skill: "Forces",
        difficulty: .highSchool,
        prompt: "A heavier box needs more force to start moving than a lighter box. Which idea does this best support?",
        choices: [
            "Mass can affect the force needed for motion.",
            "Objects move without force.",
            "Weight has no effect on motion.",
            "Only living things can move."
        ],
        correctChoiceIndex: 0,
        explanation: "The heavier box requires more force, so mass affects the force needed.",
        encouragement: "Physical science often asks you to match evidence to the idea it supports."
    )

    static let socialBranchesL1 = PracticeQuestion(
        id: "social-branches-l1-001",
        subject: .socialStudies,
        skill: "Government",
        difficulty: .foundation,
        prompt: "Which branch of government makes laws?",
        choices: ["Legislative", "Executive", "Judicial", "Local"],
        correctChoiceIndex: 0,
        explanation: "The legislative branch, including Congress, makes laws.",
        encouragement: "Branch questions get easier when each branch has one main job."
    )

    static let socialMapL2 = PracticeQuestion(
        id: "social-map-l2-001",
        subject: .socialStudies,
        skill: "Maps",
        difficulty: .fundamentals,
        prompt: "A map key shows a dotted line for hiking trails. What does a dotted line on the map most likely represent?",
        choices: ["A river", "A hiking trail", "A city border", "A mountain peak"],
        correctChoiceIndex: 1,
        explanation: "A map key explains symbols. If the key says dotted line means trail, use that clue.",
        encouragement: "Map questions usually hand you a tool. Use the key first."
    )

    static let socialSupplyDemandL2 = PracticeQuestion(
        id: "social-economics-l2-001",
        subject: .socialStudies,
        skill: "Economics",
        difficulty: .fundamentals,
        prompt: "If many people want a product but few stores have it, what often happens to the price?",
        choices: ["It often rises", "It always disappears", "It becomes free", "It cannot change"],
        correctChoiceIndex: 0,
        explanation: "High demand and low supply often push prices higher.",
        encouragement: "Economics questions often ask how choices affect prices and resources."
    )

    static let socialFoundingL3 = PracticeQuestion(
        id: "social-history-l3-001",
        subject: .socialStudies,
        skill: "U.S. History",
        difficulty: .highSchool,
        prompt: "Colonists protested taxation without representation because they believed taxes should be approved by whom?",
        choices: ["Foreign kings only", "People's representatives", "Military leaders", "Private companies"],
        correctChoiceIndex: 1,
        explanation: "The phrase points to the belief that elected representatives should have a voice in taxes.",
        encouragement: "History questions often hide the answer in the meaning of a phrase."
    )

    static let socialChecksL4 = PracticeQuestion(
        id: "social-civics-l4-001",
        subject: .socialStudies,
        skill: "Civics",
        difficulty: .hisetReady,
        prompt: "Why does the U.S. Constitution divide power among three branches of government?",
        choices: [
            "To prevent any one branch from becoming too powerful",
            "To remove voting rights",
            "To make state governments illegal",
            "To let one person make every law"
        ],
        correctChoiceIndex: 0,
        explanation: "Dividing power creates checks and balances, which limits the power of each branch.",
        encouragement: "This is a key Social Studies idea. Three branches are a protection system."
    )
}


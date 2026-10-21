import 'package:flutter/material.dart';
import '../models/quiz_category.dart';
import '../models/quiz_question.dart';

class QuizData {
  static final List<QuizCategory> categories = [
    QuizCategory(
      id: 'science',
      name: 'Science & Nature',
      description: 'Explore the universe, chemistry, biology, and the natural world.',
      icon: Icons.science_rounded,
      primaryColor: const Color(0xFF1E88E5), // Blue
      accentColor: const Color(0xFF64B5F6),
      questions: const [
        QuizQuestion(
          id: 'sci_1',
          question: 'What is the chemical symbol for Gold?',
          options: ['Au', 'Ag', 'Gd', 'Go'],
          correctOptionIndex: 0,
          explanation: 'Au comes from the Latin word for gold, "Aurum".',
        ),
        QuizQuestion(
          id: 'sci_2',
          question: 'Which planet in our solar system has the highest number of moons?',
          options: ['Jupiter', 'Saturn', 'Uranus', 'Mars'],
          correctOptionIndex: 1,
          explanation: 'Saturn has over 140 confirmed moons, surpassing Jupiter.',
        ),
        QuizQuestion(
          id: 'sci_3',
          question: 'What gas do plants absorb from the atmosphere during photosynthesis?',
          options: ['Oxygen', 'Carbon Dioxide', 'Nitrogen', 'Hydrogen'],
          correctOptionIndex: 1,
          explanation: 'Plants use carbon dioxide and sunlight to produce glucose and oxygen.',
        ),
        QuizQuestion(
          id: 'sci_4',
          question: 'What is the hardest naturally occurring substance on Earth?',
          options: ['Titanium', 'Granite', 'Diamond', 'Graphene'],
          correctOptionIndex: 2,
          explanation: 'Diamond is formed of carbon atoms arranged in a crystal lattice and is the hardest mineral.',
        ),
        QuizQuestion(
          id: 'sci_5',
          question: 'How many bones are there in an adult human body?',
          options: ['186', '206', '216', '224'],
          correctOptionIndex: 1,
          explanation: 'Humans are born with about 270 bones, which fuse into 206 bones in adulthood.',
        ),
      ],
    ),
    QuizCategory(
      id: 'history_geo',
      name: 'History & Geography',
      description: 'Journey across world capitals, landmarks, and historic milestones.',
      icon: Icons.public_rounded,
      primaryColor: const Color(0xFF43A047), // Green
      accentColor: const Color(0xFF81C784),
      questions: const [
        QuizQuestion(
          id: 'hist_1',
          question: 'What is the capital city of Australia?',
          options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'],
          correctOptionIndex: 2,
          explanation: 'Canberra was selected as a compromise between Sydney and Melbourne in 1908.',
        ),
        QuizQuestion(
          id: 'hist_2',
          question: 'Which ancient wonder of the world is the only one still standing today?',
          options: [
            'Colossus of Rhodes',
            'Great Pyramid of Giza',
            'Hanging Gardens of Babylon',
            'Lighthouse of Alexandria',
          ],
          correctOptionIndex: 1,
          explanation: 'The Great Pyramid of Giza is the oldest and only intact Wonder of the Ancient World.',
        ),
        QuizQuestion(
          id: 'hist_3',
          question: 'What is traditionally considered the longest river in the world?',
          options: ['Amazon River', 'Nile River', 'Yangtze River', 'Mississippi River'],
          correctOptionIndex: 1,
          explanation: 'The Nile spans approximately 6,650 kilometers (4,132 miles) through northeastern Africa.',
        ),
        QuizQuestion(
          id: 'hist_4',
          question: 'In which year did the Apollo 11 mission land humans on the Moon?',
          options: ['1965', '1969', '1971', '1974'],
          correctOptionIndex: 1,
          explanation: 'Neil Armstrong and Buzz Aldrin landed the Lunar Module Eagle on July 20, 1969.',
        ),
        QuizQuestion(
          id: 'hist_5',
          question: 'Which country has the highest number of natural lakes in the world?',
          options: ['United States', 'Russia', 'Canada', 'Finland'],
          correctOptionIndex: 2,
          explanation: 'Canada contains more than half of all the natural lakes in the entire world.',
        ),
      ],
    ),
    QuizCategory(
      id: 'technology',
      name: 'Technology & Computing',
      description: 'Test your knowledge on computers, algorithms, the internet, and gadgets.',
      icon: Icons.memory_rounded,
      primaryColor: const Color(0xFF8E24AA), // Purple
      accentColor: const Color(0xFFBA68C8),
      questions: const [
        QuizQuestion(
          id: 'tech_1',
          question: 'Who is widely regarded as the father of theoretical computer science and AI?',
          options: ['Charles Babbage', 'Alan Turing', 'John von Neumann', 'Steve Wozniak'],
          correctOptionIndex: 1,
          explanation: 'Alan Turing formalized concepts of algorithm and computation with the Turing Machine.',
        ),
        QuizQuestion(
          id: 'tech_2',
          question: 'What programming language was developed by Google and powers Flutter?',
          options: ['Go', 'Kotlin', 'Dart', 'Rust'],
          correctOptionIndex: 2,
          explanation: 'Dart is an object-oriented, client-optimized language created by Google for fast apps.',
        ),
        QuizQuestion(
          id: 'tech_3',
          question: 'In what year was the first Apple iPhone officially released?',
          options: ['2005', '2007', '2009', '2010'],
          correctOptionIndex: 1,
          explanation: 'Steve Jobs introduced the first-generation iPhone in January 2007, launching in June 2007.',
        ),
        QuizQuestion(
          id: 'tech_4',
          question: 'What does the acronym "GPU" stand for in computing hardware?',
          options: [
            'General Processing Unit',
            'Graphic Protocol Utility',
            'Graphics Processing Unit',
            'Grid Parallel Unit',
          ],
          correctOptionIndex: 2,
          explanation: 'A GPU specializes in rendering images, video, and massively parallel computation.',
        ),
        QuizQuestion(
          id: 'tech_5',
          question: 'What does "HTTP" stand for in web network communications?',
          options: [
            'HyperText Transfer Protocol',
            'High-speed Traffic Transport Path',
            'HyperText Transmission Parser',
            'Host Terminal Tracking Protocol',
          ],
          correctOptionIndex: 0,
          explanation: 'HTTP is the foundational protocol used for transmitting web documents over the internet.',
        ),
      ],
    ),
    QuizCategory(
      id: 'sports',
      name: 'Sports & Games',
      description: 'From football to chess, challenge yourself with athletic and strategy trivia.',
      icon: Icons.sports_soccer_rounded,
      primaryColor: const Color(0xFFF4511E), // Deep Orange
      accentColor: const Color(0xFFFF8A65),
      questions: const [
        QuizQuestion(
          id: 'sport_1',
          question: 'How many players are on the pitch for one team in a regulation football (soccer) match?',
          options: ['9', '10', '11', '12'],
          correctOptionIndex: 2,
          explanation: 'A soccer team consists of 11 players including 1 goalkeeper.',
        ),
        QuizQuestion(
          id: 'sport_2',
          question: 'Which country won the inaugural FIFA Men\'s World Cup in 1930?',
          options: ['Brazil', 'Argentina', 'Uruguay', 'Italy'],
          correctOptionIndex: 2,
          explanation: 'Uruguay hosted the tournament and defeated Argentina 4-2 in the final.',
        ),
        QuizQuestion(
          id: 'sport_3',
          question: 'In tennis scoring terminology, what does the word "Love" represent?',
          options: ['Advantage', 'Zero score', 'Deuce', 'Tiebreak'],
          correctOptionIndex: 1,
          explanation: '"Love" comes from the French word "l\'oeuf" (the egg), resembling a zero.',
        ),
        QuizQuestion(
          id: 'sport_4',
          question: 'How many total squares are on a standard tournament chessboard?',
          options: ['48', '64', '81', '100'],
          correctOptionIndex: 1,
          explanation: 'A chessboard has an 8x8 grid of alternating light and dark squares, totaling 64.',
        ),
        QuizQuestion(
          id: 'sport_5',
          question: 'In standard cricket rules, how many legal balls are bowled per over?',
          options: ['4', '5', '6', '8'],
          correctOptionIndex: 2,
          explanation: 'An over consists of six consecutive legal deliveries by the bowler.',
        ),
      ],
    ),
    QuizCategory(
      id: 'general_trivia',
      name: 'General Trivia',
      description: 'Fascinating curiosities, arts, literature, and worldwide facts.',
      icon: Icons.lightbulb_rounded,
      primaryColor: const Color(0xFF00897B), // Teal
      accentColor: const Color(0xFF4DB6AC),
      questions: const [
        QuizQuestion(
          id: 'gen_1',
          question: 'Which sea creature is famous for having three hearts and blue blood?',
          options: ['Dolphin', 'Octopus', 'Sea Turtle', 'Jellyfish'],
          correctOptionIndex: 1,
          explanation: 'An octopus has three hearts: two pump blood to the gills, and one pumps to the body.',
        ),
        QuizQuestion(
          id: 'gen_2',
          question: 'Who painted the world-famous portrait "Mona Lisa"?',
          options: ['Vincent van Gogh', 'Pablo Picasso', 'Leonardo da Vinci', 'Michelangelo'],
          correctOptionIndex: 2,
          explanation: 'Leonardo da Vinci painted the Mona Lisa in Florence in the early 16th century.',
        ),
        QuizQuestion(
          id: 'gen_3',
          question: 'What is the smallest continent on Earth by total land area?',
          options: ['Europe', 'Antarctica', 'South America', 'Australia'],
          correctOptionIndex: 3,
          explanation: 'Australia is the smallest continent, covering approximately 7.69 million square kilometers.',
        ),
        QuizQuestion(
          id: 'gen_4',
          question: 'What is the approximate speed of light in vacuum?',
          options: [
            '150,000 km/s',
            '300,000 km/s',
            '450,000 km/s',
            '1,000,000 km/s',
          ],
          correctOptionIndex: 1,
          explanation: 'The speed of light in vacuum is precisely 299,792 km/s (approx. 300,000 km/s).',
        ),
        QuizQuestion(
          id: 'gen_5',
          question: 'Which country is affectionately celebrated for its cherry blossom season ("Sakura")?',
          options: ['Japan', 'South Korea', 'Vietnam', 'Thailand'],
          correctOptionIndex: 0,
          explanation: 'Sakura is an iconic cultural symbol of Japan, celebrated with Hanami festivals.',
        ),
      ],
    ),
  ];

  static QuizCategory getCategoryById(String id) {
    return categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => categories.first,
    );
  }
}

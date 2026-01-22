import 'package:flutter/material.dart';
import '../models/models.dart';

/// Complete subject catalog for SSC 2026
/// Organized by section with chapters based on short syllabus
class SubjectData {
  
  // ========================
  // COMMON SUBJECTS (All Sections)
  // ========================
  
  static Subject banglaFirstPaper = Subject(
    id: 'bangla_1st',
    name: 'Bangla 1st Paper',
    section: 'common',
    category: SubjectCategory.light,
    icon: Icons.menu_book,
    color: const Color(0xFF10B981),
    chapters: [
      Chapter(id: 'bn1_1', name: 'সুভা', subjectId: 'bangla_1st', order: 1, estimatedMinutes: 45),
      Chapter(id: 'bn1_2', name: 'বইপড়া', subjectId: 'bangla_1st', order: 2, estimatedMinutes: 45),
      Chapter(id: 'bn1_3', name: 'আম-আঁটির ভেঁপু', subjectId: 'bangla_1st', order: 3, estimatedMinutes: 45),
      Chapter(id: 'bn1_4', name: 'মানুষ মুহম্মদ (স.)', subjectId: 'bangla_1st', order: 4, estimatedMinutes: 45),
      Chapter(id: 'bn1_5', name: 'নিমগাছ', subjectId: 'bangla_1st', order: 5, estimatedMinutes: 45),
      Chapter(id: 'bn1_6', name: 'শিক্ষা ও মনুষ্যত্ব', subjectId: 'bangla_1st', order: 6, estimatedMinutes: 45),
      Chapter(id: 'bn1_7', name: 'প্রবাস বন্ধু', subjectId: 'bangla_1st', order: 7, estimatedMinutes: 45),
      Chapter(id: 'bn1_8', name: 'পদচিহ্ন (কবিতা)', subjectId: 'bangla_1st', order: 8, estimatedMinutes: 30),
      Chapter(id: 'bn1_9', name: 'জাগো তবে অর্ণব', subjectId: 'bangla_1st', order: 9, estimatedMinutes: 30),
      Chapter(id: 'bn1_10', name: 'অন্যান্য কবিতা ও প্রবন্ধ', subjectId: 'bangla_1st', order: 10, estimatedMinutes: 60),
    ],
  );

  static Subject banglaSecondPaper = Subject(
    id: 'bangla_2nd',
    name: 'Bangla 2nd Paper',
    section: 'common',
    category: SubjectCategory.light,
    icon: Icons.edit_note,
    color: const Color(0xFF059669),
    chapters: [
      Chapter(id: 'bn2_1', name: 'ভাষা ও ব্যাকরণ', subjectId: 'bangla_2nd', order: 1, estimatedMinutes: 60),
      Chapter(id: 'bn2_2', name: 'ধ্বনিতত্ত্ব', subjectId: 'bangla_2nd', order: 2, estimatedMinutes: 45),
      Chapter(id: 'bn2_3', name: 'শব্দতত্ত্ব', subjectId: 'bangla_2nd', order: 3, estimatedMinutes: 45),
      Chapter(id: 'bn2_4', name: 'পদ প্রকরণ', subjectId: 'bangla_2nd', order: 4, estimatedMinutes: 60),
      Chapter(id: 'bn2_5', name: 'বাক্যতত্ত্ব', subjectId: 'bangla_2nd', order: 5, estimatedMinutes: 45),
      Chapter(id: 'bn2_6', name: 'রচনা ও প্রয়োগ', subjectId: 'bangla_2nd', order: 6, estimatedMinutes: 60),
      Chapter(id: 'bn2_7', name: 'পত্র লিখন', subjectId: 'bangla_2nd', order: 7, estimatedMinutes: 45),
      Chapter(id: 'bn2_8', name: 'প্রতিবেদন ও আবেদন', subjectId: 'bangla_2nd', order: 8, estimatedMinutes: 45),
    ],
  );

  static Subject englishFirstPaper = Subject(
    id: 'english_1st',
    name: 'English 1st Paper',
    section: 'common',
    category: SubjectCategory.light,
    icon: Icons.language,
    color: const Color(0xFF3B82F6),
    chapters: [
      Chapter(id: 'en1_1', name: 'Reading Comprehension - Unit 1-3', subjectId: 'english_1st', order: 1, estimatedMinutes: 60),
      Chapter(id: 'en1_2', name: 'Reading Comprehension - Unit 4-6', subjectId: 'english_1st', order: 2, estimatedMinutes: 60),
      Chapter(id: 'en1_3', name: 'Reading Comprehension - Unit 7-9', subjectId: 'english_1st', order: 3, estimatedMinutes: 60),
      Chapter(id: 'en1_4', name: 'Seen Passages', subjectId: 'english_1st', order: 4, estimatedMinutes: 45),
      Chapter(id: 'en1_5', name: 'Unseen Passages', subjectId: 'english_1st', order: 5, estimatedMinutes: 45),
      Chapter(id: 'en1_6', name: 'Summary Writing', subjectId: 'english_1st', order: 6, estimatedMinutes: 45),
    ],
  );

  static Subject englishSecondPaper = Subject(
    id: 'english_2nd',
    name: 'English 2nd Paper',
    section: 'common',
    category: SubjectCategory.light,
    icon: Icons.spellcheck,
    color: const Color(0xFF2563EB),
    chapters: [
      Chapter(id: 'en2_1', name: 'Grammar - Tenses', subjectId: 'english_2nd', order: 1, estimatedMinutes: 60),
      Chapter(id: 'en2_2', name: 'Grammar - Voice & Narration', subjectId: 'english_2nd', order: 2, estimatedMinutes: 60),
      Chapter(id: 'en2_3', name: 'Grammar - Preposition & Articles', subjectId: 'english_2nd', order: 3, estimatedMinutes: 45),
      Chapter(id: 'en2_4', name: 'Grammar - Sentence & Transformation', subjectId: 'english_2nd', order: 4, estimatedMinutes: 60),
      Chapter(id: 'en2_5', name: 'Writing - Paragraph', subjectId: 'english_2nd', order: 5, estimatedMinutes: 45),
      Chapter(id: 'en2_6', name: 'Writing - Composition', subjectId: 'english_2nd', order: 6, estimatedMinutes: 45),
      Chapter(id: 'en2_7', name: 'Writing - Letter & Email', subjectId: 'english_2nd', order: 7, estimatedMinutes: 45),
      Chapter(id: 'en2_8', name: 'CV & Dialogue Writing', subjectId: 'english_2nd', order: 8, estimatedMinutes: 45),
    ],
  );

  static Subject generalMath = Subject(
    id: 'math',
    name: 'General Mathematics',
    section: 'common',
    category: SubjectCategory.heavy,
    icon: Icons.calculate,
    color: const Color(0xFFEF4444),
    chapters: [
      Chapter(id: 'math_1', name: 'Real Numbers', subjectId: 'math', order: 1, estimatedMinutes: 90),
      Chapter(id: 'math_2', name: 'Sets & Functions', subjectId: 'math', order: 2, estimatedMinutes: 90),
      Chapter(id: 'math_3', name: 'Algebraic Expressions', subjectId: 'math', order: 3, estimatedMinutes: 90),
      Chapter(id: 'math_4', name: 'Linear Equations', subjectId: 'math', order: 4, estimatedMinutes: 90),
      Chapter(id: 'math_5', name: 'Quadratic Equations', subjectId: 'math', order: 5, estimatedMinutes: 90),
      Chapter(id: 'math_6', name: 'Simple Interest', subjectId: 'math', order: 6, estimatedMinutes: 60),
      Chapter(id: 'math_7', name: 'Ratio & Proportion', subjectId: 'math', order: 7, estimatedMinutes: 60),
      Chapter(id: 'math_8', name: 'Statistics', subjectId: 'math', order: 8, estimatedMinutes: 90),
      Chapter(id: 'math_9', name: 'Geometry - Triangles', subjectId: 'math', order: 9, estimatedMinutes: 90),
      Chapter(id: 'math_10', name: 'Geometry - Circles', subjectId: 'math', order: 10, estimatedMinutes: 90),
      Chapter(id: 'math_11', name: 'Trigonometry', subjectId: 'math', order: 11, estimatedMinutes: 90),
      Chapter(id: 'math_12', name: 'Mensuration', subjectId: 'math', order: 12, estimatedMinutes: 90),
    ],
  );

  static Subject ict = Subject(
    id: 'ict',
    name: 'ICT',
    section: 'common',
    category: SubjectCategory.light,
    icon: Icons.computer,
    color: const Color(0xFF06B6D4),
    chapters: [
      Chapter(id: 'ict_1', name: 'Information & Communication Technology', subjectId: 'ict', order: 1, estimatedMinutes: 45),
      Chapter(id: 'ict_2', name: 'Computer & Its Components', subjectId: 'ict', order: 2, estimatedMinutes: 45),
      Chapter(id: 'ict_3', name: 'Number System', subjectId: 'ict', order: 3, estimatedMinutes: 60),
      Chapter(id: 'ict_4', name: 'Website & HTML', subjectId: 'ict', order: 4, estimatedMinutes: 60),
      Chapter(id: 'ict_5', name: 'Spreadsheet', subjectId: 'ict', order: 5, estimatedMinutes: 45),
      Chapter(id: 'ict_6', name: 'Database', subjectId: 'ict', order: 6, estimatedMinutes: 45),
    ],
  );

  static Subject islamicStudies = Subject(
    id: 'islam',
    name: 'Islamic Studies',
    section: 'common',
    category: SubjectCategory.light,
    icon: Icons.mosque,
    color: const Color(0xFF22C55E),
    chapters: [
      Chapter(id: 'isl_1', name: 'আকাইদ', subjectId: 'islam', order: 1, estimatedMinutes: 45),
      Chapter(id: 'isl_2', name: 'ইবাদত', subjectId: 'islam', order: 2, estimatedMinutes: 45),
      Chapter(id: 'isl_3', name: 'কুরআন শিক্ষা', subjectId: 'islam', order: 3, estimatedMinutes: 60),
      Chapter(id: 'isl_4', name: 'হাদিস শরিফ', subjectId: 'islam', order: 4, estimatedMinutes: 45),
      Chapter(id: 'isl_5', name: 'আখলাক', subjectId: 'islam', order: 5, estimatedMinutes: 45),
      Chapter(id: 'isl_6', name: 'ইসলামি সংস্কৃতি', subjectId: 'islam', order: 6, estimatedMinutes: 45),
    ],
  );

  // ========================
  // SCIENCE SUBJECTS
  // ========================

  static Subject physics = Subject(
    id: 'physics',
    name: 'Physics',
    section: 'science',
    category: SubjectCategory.heavy,
    icon: Icons.science,
    color: const Color(0xFFF97316),
    chapters: [
      Chapter(id: 'phy_1', name: 'Physical Quantities & Measurement', subjectId: 'physics', order: 1, estimatedMinutes: 90),
      Chapter(id: 'phy_2', name: 'Motion', subjectId: 'physics', order: 2, estimatedMinutes: 90),
      Chapter(id: 'phy_3', name: 'Force', subjectId: 'physics', order: 3, estimatedMinutes: 90),
      Chapter(id: 'phy_4', name: 'Work, Energy & Power', subjectId: 'physics', order: 4, estimatedMinutes: 90),
      Chapter(id: 'phy_5', name: 'States of Matter', subjectId: 'physics', order: 5, estimatedMinutes: 60),
      Chapter(id: 'phy_6', name: 'Sound', subjectId: 'physics', order: 6, estimatedMinutes: 60),
      Chapter(id: 'phy_7', name: 'Light', subjectId: 'physics', order: 7, estimatedMinutes: 90),
      Chapter(id: 'phy_8', name: 'Static Electricity', subjectId: 'physics', order: 8, estimatedMinutes: 90),
      Chapter(id: 'phy_9', name: 'Current Electricity', subjectId: 'physics', order: 9, estimatedMinutes: 90),
      Chapter(id: 'phy_10', name: 'Magnetism', subjectId: 'physics', order: 10, estimatedMinutes: 60),
      Chapter(id: 'phy_11', name: 'Modern Physics', subjectId: 'physics', order: 11, estimatedMinutes: 60),
    ],
  );

  static Subject chemistry = Subject(
    id: 'chemistry',
    name: 'Chemistry',
    section: 'science',
    category: SubjectCategory.heavy,
    icon: Icons.biotech,
    color: const Color(0xFFA855F7),
    chapters: [
      Chapter(id: 'chem_1', name: 'Chemical Substances & Their Properties', subjectId: 'chemistry', order: 1, estimatedMinutes: 90),
      Chapter(id: 'chem_2', name: 'Atomic Structure', subjectId: 'chemistry', order: 2, estimatedMinutes: 90),
      Chapter(id: 'chem_3', name: 'Periodic Table', subjectId: 'chemistry', order: 3, estimatedMinutes: 60),
      Chapter(id: 'chem_4', name: 'Chemical Bonding', subjectId: 'chemistry', order: 4, estimatedMinutes: 90),
      Chapter(id: 'chem_5', name: 'Chemical Reactions', subjectId: 'chemistry', order: 5, estimatedMinutes: 90),
      Chapter(id: 'chem_6', name: 'Mole Concept', subjectId: 'chemistry', order: 6, estimatedMinutes: 90),
      Chapter(id: 'chem_7', name: 'Acids, Bases & Salts', subjectId: 'chemistry', order: 7, estimatedMinutes: 90),
      Chapter(id: 'chem_8', name: 'Chemicals in Industries', subjectId: 'chemistry', order: 8, estimatedMinutes: 60),
      Chapter(id: 'chem_9', name: 'Organic Chemistry', subjectId: 'chemistry', order: 9, estimatedMinutes: 90),
      Chapter(id: 'chem_10', name: 'Environmental Chemistry', subjectId: 'chemistry', order: 10, estimatedMinutes: 60),
    ],
  );

  static Subject biology = Subject(
    id: 'biology',
    name: 'Biology',
    section: 'science',
    category: SubjectCategory.moderate,
    icon: Icons.eco,
    color: const Color(0xFF22C55E),
    chapters: [
      Chapter(id: 'bio_1', name: 'Cell & Cell Division', subjectId: 'biology', order: 1, estimatedMinutes: 60),
      Chapter(id: 'bio_2', name: 'Tissues', subjectId: 'biology', order: 2, estimatedMinutes: 60),
      Chapter(id: 'bio_3', name: 'Nutrition in Plants', subjectId: 'biology', order: 3, estimatedMinutes: 60),
      Chapter(id: 'bio_4', name: 'Animal Nutrition', subjectId: 'biology', order: 4, estimatedMinutes: 60),
      Chapter(id: 'bio_5', name: 'Transport System', subjectId: 'biology', order: 5, estimatedMinutes: 60),
      Chapter(id: 'bio_6', name: 'Respiration', subjectId: 'biology', order: 6, estimatedMinutes: 60),
      Chapter(id: 'bio_7', name: 'Excretion', subjectId: 'biology', order: 7, estimatedMinutes: 60),
      Chapter(id: 'bio_8', name: 'Coordination & Control', subjectId: 'biology', order: 8, estimatedMinutes: 60),
      Chapter(id: 'bio_9', name: 'Reproduction', subjectId: 'biology', order: 9, estimatedMinutes: 60),
      Chapter(id: 'bio_10', name: 'Genetics & Evolution', subjectId: 'biology', order: 10, estimatedMinutes: 60),
      Chapter(id: 'bio_11', name: 'Ecosystem', subjectId: 'biology', order: 11, estimatedMinutes: 45),
    ],
  );

  static Subject higherMath = Subject(
    id: 'higher_math',
    name: 'Higher Mathematics',
    section: 'science',
    category: SubjectCategory.heavy,
    icon: Icons.functions,
    color: const Color(0xFFDC2626),
    chapters: [
      Chapter(id: 'hm_1', name: 'Real Numbers', subjectId: 'higher_math', order: 1, estimatedMinutes: 90),
      Chapter(id: 'hm_2', name: 'Sets & Functions', subjectId: 'higher_math', order: 2, estimatedMinutes: 90),
      Chapter(id: 'hm_3', name: 'Algebraic Formulas', subjectId: 'higher_math', order: 3, estimatedMinutes: 90),
      Chapter(id: 'hm_4', name: 'Indices & Logarithms', subjectId: 'higher_math', order: 4, estimatedMinutes: 90),
      Chapter(id: 'hm_5', name: 'Linear Equations', subjectId: 'higher_math', order: 5, estimatedMinutes: 90),
      Chapter(id: 'hm_6', name: 'Quadratic Equations', subjectId: 'higher_math', order: 6, estimatedMinutes: 90),
      Chapter(id: 'hm_7', name: 'Polynomial Equations', subjectId: 'higher_math', order: 7, estimatedMinutes: 90),
      Chapter(id: 'hm_8', name: 'Straight Lines', subjectId: 'higher_math', order: 8, estimatedMinutes: 90),
      Chapter(id: 'hm_9', name: 'Circles', subjectId: 'higher_math', order: 9, estimatedMinutes: 90),
      Chapter(id: 'hm_10', name: 'Trigonometry', subjectId: 'higher_math', order: 10, estimatedMinutes: 90),
      Chapter(id: 'hm_11', name: 'Mensuration', subjectId: 'higher_math', order: 11, estimatedMinutes: 90),
      Chapter(id: 'hm_12', name: 'Statistics & Probability', subjectId: 'higher_math', order: 12, estimatedMinutes: 90),
    ],
  );

  // ========================
  // HUMANITIES SUBJECTS
  // ========================

  static Subject bgs = Subject(
    id: 'bgs',
    name: 'Bangladesh & Global Studies',
    section: 'humanities',
    category: SubjectCategory.moderate,
    icon: Icons.public,
    color: const Color(0xFF14B8A6),
    chapters: [
      Chapter(id: 'bgs_1', name: 'East Bengal in Pakistan Era', subjectId: 'bgs', order: 1, estimatedMinutes: 60),
      Chapter(id: 'bgs_2', name: 'Liberation War', subjectId: 'bgs', order: 2, estimatedMinutes: 60),
      Chapter(id: 'bgs_3', name: 'State & Government', subjectId: 'bgs', order: 3, estimatedMinutes: 60),
      Chapter(id: 'bgs_4', name: 'Citizenship', subjectId: 'bgs', order: 4, estimatedMinutes: 45),
      Chapter(id: 'bgs_5', name: 'Social Problems', subjectId: 'bgs', order: 5, estimatedMinutes: 60),
      Chapter(id: 'bgs_6', name: 'Economy of Bangladesh', subjectId: 'bgs', order: 6, estimatedMinutes: 60),
      Chapter(id: 'bgs_7', name: 'Population & Culture', subjectId: 'bgs', order: 7, estimatedMinutes: 45),
      Chapter(id: 'bgs_8', name: 'International Relations', subjectId: 'bgs', order: 8, estimatedMinutes: 60),
      Chapter(id: 'bgs_9', name: 'United Nations', subjectId: 'bgs', order: 9, estimatedMinutes: 45),
    ],
  );

  static Subject economics = Subject(
    id: 'economics',
    name: 'Economics',
    section: 'humanities',
    category: SubjectCategory.moderate,
    icon: Icons.trending_up,
    color: const Color(0xFF8B5CF6),
    chapters: [
      Chapter(id: 'eco_1', name: 'Economics & Its Scope', subjectId: 'economics', order: 1, estimatedMinutes: 60),
      Chapter(id: 'eco_2', name: 'Demand & Supply', subjectId: 'economics', order: 2, estimatedMinutes: 60),
      Chapter(id: 'eco_3', name: 'Production', subjectId: 'economics', order: 3, estimatedMinutes: 60),
      Chapter(id: 'eco_4', name: 'Money & Banking', subjectId: 'economics', order: 4, estimatedMinutes: 60),
      Chapter(id: 'eco_5', name: 'National Income', subjectId: 'economics', order: 5, estimatedMinutes: 60),
      Chapter(id: 'eco_6', name: 'Trade & Commerce', subjectId: 'economics', order: 6, estimatedMinutes: 45),
      Chapter(id: 'eco_7', name: 'Public Finance', subjectId: 'economics', order: 7, estimatedMinutes: 45),
      Chapter(id: 'eco_8', name: 'Economic Development', subjectId: 'economics', order: 8, estimatedMinutes: 60),
    ],
  );

  static Subject civics = Subject(
    id: 'civics',
    name: 'Civics & Citizenship',
    section: 'humanities',
    category: SubjectCategory.moderate,
    icon: Icons.gavel,
    color: const Color(0xFFF59E0B),
    chapters: [
      Chapter(id: 'civ_1', name: 'Civics & Citizenship', subjectId: 'civics', order: 1, estimatedMinutes: 45),
      Chapter(id: 'civ_2', name: 'State', subjectId: 'civics', order: 2, estimatedMinutes: 60),
      Chapter(id: 'civ_3', name: 'Law & Justice', subjectId: 'civics', order: 3, estimatedMinutes: 60),
      Chapter(id: 'civ_4', name: 'Democracy', subjectId: 'civics', order: 4, estimatedMinutes: 60),
      Chapter(id: 'civ_5', name: 'Constitution', subjectId: 'civics', order: 5, estimatedMinutes: 60),
      Chapter(id: 'civ_6', name: 'Rights & Duties', subjectId: 'civics', order: 6, estimatedMinutes: 45),
      Chapter(id: 'civ_7', name: 'Local Government', subjectId: 'civics', order: 7, estimatedMinutes: 45),
    ],
  );

  static Subject geography = Subject(
    id: 'geography',
    name: 'Geography & Environment',
    section: 'humanities',
    category: SubjectCategory.moderate,
    icon: Icons.terrain,
    color: const Color(0xFF84CC16),
    chapters: [
      Chapter(id: 'geo_1', name: 'Geography & Environment', subjectId: 'geography', order: 1, estimatedMinutes: 45),
      Chapter(id: 'geo_2', name: 'The Earth', subjectId: 'geography', order: 2, estimatedMinutes: 60),
      Chapter(id: 'geo_3', name: 'Atmosphere', subjectId: 'geography', order: 3, estimatedMinutes: 60),
      Chapter(id: 'geo_4', name: 'Hydrosphere', subjectId: 'geography', order: 4, estimatedMinutes: 60),
      Chapter(id: 'geo_5', name: 'Lithosphere', subjectId: 'geography', order: 5, estimatedMinutes: 60),
      Chapter(id: 'geo_6', name: 'Bangladesh Geography', subjectId: 'geography', order: 6, estimatedMinutes: 60),
      Chapter(id: 'geo_7', name: 'Population & Settlements', subjectId: 'geography', order: 7, estimatedMinutes: 45),
      Chapter(id: 'geo_8', name: 'Natural Disasters', subjectId: 'geography', order: 8, estimatedMinutes: 45),
    ],
  );

  // ========================
  // COMMERCE SUBJECTS
  // ========================

  static Subject accounting = Subject(
    id: 'accounting',
    name: 'Accounting',
    section: 'commerce',
    category: SubjectCategory.moderate,
    icon: Icons.account_balance,
    color: const Color(0xFF0EA5E9),
    chapters: [
      Chapter(id: 'acc_1', name: 'Introduction to Accounting', subjectId: 'accounting', order: 1, estimatedMinutes: 60),
      Chapter(id: 'acc_2', name: 'Transaction & Ledger', subjectId: 'accounting', order: 2, estimatedMinutes: 90),
      Chapter(id: 'acc_3', name: 'Journal & Posting', subjectId: 'accounting', order: 3, estimatedMinutes: 90),
      Chapter(id: 'acc_4', name: 'Cash Book', subjectId: 'accounting', order: 4, estimatedMinutes: 60),
      Chapter(id: 'acc_5', name: 'Trial Balance', subjectId: 'accounting', order: 5, estimatedMinutes: 60),
      Chapter(id: 'acc_6', name: 'Adjustments', subjectId: 'accounting', order: 6, estimatedMinutes: 90),
      Chapter(id: 'acc_7', name: 'Financial Statements', subjectId: 'accounting', order: 7, estimatedMinutes: 90),
      Chapter(id: 'acc_8', name: 'Manufacturing Accounts', subjectId: 'accounting', order: 8, estimatedMinutes: 60),
    ],
  );

  static Subject financeAndBanking = Subject(
    id: 'finance',
    name: 'Finance & Banking',
    section: 'commerce',
    category: SubjectCategory.moderate,
    icon: Icons.attach_money,
    color: const Color(0xFF10B981),
    chapters: [
      Chapter(id: 'fin_1', name: 'Finance & Financial Institutions', subjectId: 'finance', order: 1, estimatedMinutes: 60),
      Chapter(id: 'fin_2', name: 'Time Value of Money', subjectId: 'finance', order: 2, estimatedMinutes: 90),
      Chapter(id: 'fin_3', name: 'Investment', subjectId: 'finance', order: 3, estimatedMinutes: 60),
      Chapter(id: 'fin_4', name: 'Banking System', subjectId: 'finance', order: 4, estimatedMinutes: 60),
      Chapter(id: 'fin_5', name: 'Central Bank', subjectId: 'finance', order: 5, estimatedMinutes: 60),
      Chapter(id: 'fin_6', name: 'Stock Exchange', subjectId: 'finance', order: 6, estimatedMinutes: 60),
      Chapter(id: 'fin_7', name: 'Insurance', subjectId: 'finance', order: 7, estimatedMinutes: 45),
    ],
  );

  static Subject businessEntrepreneurship = Subject(
    id: 'business',
    name: 'Business Entrepreneurship',
    section: 'commerce',
    category: SubjectCategory.moderate,
    icon: Icons.business_center,
    color: const Color(0xFFF97316),
    chapters: [
      Chapter(id: 'bus_1', name: 'Business & Commerce', subjectId: 'business', order: 1, estimatedMinutes: 60),
      Chapter(id: 'bus_2', name: 'Business Ownership', subjectId: 'business', order: 2, estimatedMinutes: 60),
      Chapter(id: 'bus_3', name: 'Entrepreneurship', subjectId: 'business', order: 3, estimatedMinutes: 60),
      Chapter(id: 'bus_4', name: 'Business Organization', subjectId: 'business', order: 4, estimatedMinutes: 60),
      Chapter(id: 'bus_5', name: 'Marketing', subjectId: 'business', order: 5, estimatedMinutes: 60),
      Chapter(id: 'bus_6', name: 'Human Resource', subjectId: 'business', order: 6, estimatedMinutes: 45),
      Chapter(id: 'bus_7', name: 'Business Communication', subjectId: 'business', order: 7, estimatedMinutes: 45),
      Chapter(id: 'bus_8', name: 'Business Ethics', subjectId: 'business', order: 8, estimatedMinutes: 45),
    ],
  );

  // Science for Humanities (BGS alternative)
  static Subject generalScience = Subject(
    id: 'science',
    name: 'General Science',
    section: 'humanities',
    category: SubjectCategory.light,
    icon: Icons.science,
    color: const Color(0xFF22D3EE),
    chapters: [
      Chapter(id: 'sci_1', name: 'Life & Environment', subjectId: 'science', order: 1, estimatedMinutes: 45),
      Chapter(id: 'sci_2', name: 'Matter & Energy', subjectId: 'science', order: 2, estimatedMinutes: 45),
      Chapter(id: 'sci_3', name: 'Earth & Space', subjectId: 'science', order: 3, estimatedMinutes: 45),
      Chapter(id: 'sci_4', name: 'Human Body', subjectId: 'science', order: 4, estimatedMinutes: 45),
      Chapter(id: 'sci_5', name: 'Technology & Society', subjectId: 'science', order: 5, estimatedMinutes: 45),
    ],
  );

  // ========================
  // SUBJECT LISTS BY SECTION
  // ========================

  static List<Subject> get commonSubjects => [
    banglaFirstPaper,
    banglaSecondPaper,
    englishFirstPaper,
    englishSecondPaper,
    generalMath,
    ict,
    islamicStudies,
  ];

  static List<Subject> get scienceSubjects => [
    ...commonSubjects,
    physics,
    chemistry,
    biology,
    higherMath,
  ];

  static List<Subject> get humanitiesSubjects => [
    ...commonSubjects,
    bgs,
    economics,
    civics,
    geography,
    generalScience,
  ];

  static List<Subject> get commerceSubjects => [
    ...commonSubjects,
    accounting,
    financeAndBanking,
    businessEntrepreneurship,
    bgs,
  ];

  static List<Subject> getSubjectsForSection(String sectionId) {
    switch (sectionId) {
      case 'science':
        return scienceSubjects;
      case 'humanities':
        return humanitiesSubjects;
      case 'commerce':
        return commerceSubjects;
      default:
        return commonSubjects;
    }
  }

  static int getTotalChaptersForSection(String sectionId) {
    return getSubjectsForSection(sectionId)
        .fold(0, (sum, subject) => sum + subject.totalChapters);
  }
}

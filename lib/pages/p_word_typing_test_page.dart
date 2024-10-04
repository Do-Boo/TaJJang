import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajjang/widgets/w_progressbar.dart';
import 'package:tajjang/pages/p_setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

class WordTypingTestPage extends StatefulWidget {
  const WordTypingTestPage({super.key});

  @override
  _WordTypingTestPageState createState() => _WordTypingTestPageState();
}

class _WordTypingTestPageState extends State<WordTypingTestPage> {
  late List<String> _words;
  late ValueNotifier<String> _inputTextNotifier;
  var correctWords = 0;
  var _currentWordIndex = 0;
  final TextEditingController _textController = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  bool _isStarted = false;
  var _totalErrorWords = 0;
  var _totalCorrectWords = 0;
  int _totalTypedCharacters = 0;
  int _correctCharacters = 0;
  final List<double> _wordSpeeds = [];
  final Stopwatch _wordStopwatch = Stopwatch();
  double _currentWordSpeed = 0;
  bool _isCurrentWordStarted = false;
  bool _isNewWord = true;

  int _wordCount = 20;
  String _language = '영어';
  int _targetSpeed = 200;
  String _mode = '단어'; // '단어' 또는 '문장'

  final String _lastCompletedInput = '';
  List<String> _decomposedCurrentWord = [];
  List<String> _decomposedInput = [];

  // 한글 자모음 분리 함수
  List<String> decomposeKorean(String text) {
    List<String> result = [];
    for (int i = 0; i < text.length; i++) {
      int charCode = text.codeUnitAt(i);
      if (charCode >= 0xAC00 && charCode <= 0xD7A3) {
        int baseCode = charCode - 0xAC00;
        int chosung = baseCode ~/ (21 * 28);
        int jungsung = (baseCode % (21 * 28)) ~/ 28;
        int jongsung = baseCode % 28;
        result.add(String.fromCharCode(0x1100 + chosung));
        result.add(String.fromCharCode(0x1161 + jungsung));
        if (jongsung > 0) {
          result.add(String.fromCharCode(0x11A7 + jongsung));
        }
      } else {
        result.add(text[i]);
      }
    }
    return result;
  }

  static final List<String> _koreanSentences = [
    '매일 아침 일어나면 감사한 마음으로 하루를 시작합니다',
    '어려움이 있어도 포기하지 않고 끝까지 도전하는 것이 중요합니다',
    '가족과 함께하는 시간은 인생에서 가장 소중한 순간입니다',
    '새로운 경험을 통해 우리는 더 넓은 세상을 볼 수 있습니다',
    '작은 친절이 모여 세상을 더 아름답게 만들 수 있습니다',
    '꾸준한 노력과 열정이 있다면 어떤 꿈도 이룰 수 있습니다',
    '다른 사람의 입장에서 생각해보면 세상이 달라 보입니다',
    '건강한 몸과 마음을 위해 규칙적인 운동과 식습관이 중요합니다',
    '책을 통해 새로운 지식을 얻고 상상력을 키울 수 있습니다',
    '서로 존중하고 배려하는 마음이 행복한 사회를 만듭니다',
    '실패를 두려워하지 말고 그 속에서 배움을 찾으세요',
    '자연과 함께하는 시간은 우리에게 평화와 안정을 줍니다',
    '긍정적인 마인드로 살면 어려움도 기회로 바뀔 수 있습니다',
    '다양성을 인정하고 받아들이는 것이 성숙한 사회의 모습입니다',
    '좋은 습관을 만들면 그것이 우리의 인생을 변화시킵니다',
    '서로 돕고 나누는 삶이 우리 모두를 더 풍요롭게 만듭니다',
    '새로운 기술을 배우는 것은 우리의 미래를 준비하는 일입니다',
    '가족과 친구들과의 소중한 추억을 많이 만들어 가세요',
    '어려운 상황에서도 희망을 잃지 않는 것이 중요합니다',
    '매일 조금씩 성장하다 보면 큰 변를 이룰 수 있습니다',
    '타인을 이해하고 공감하는 능력이 좋은 관계를 만듭니다',
    '��신을 사랑하고 존중하는 것에서 모든 행복이 시작됩니다',
    '환경을 생각하는 작은 실천들이 지구를 지킬 수 있습니다',
    '어린 시절의 꿈을 잊지 말고 그것을 향해 나아가세요',
    '서로 다른 의견을 존중하며 대화하는 것이 중요합니다',
    '인생의 모든 순간이 의미 있고 소중하다는 것을 기억하세요',
    '어려움을 겪는 이웃에게 따뜻한 손길을 내밀어 주세요',
    '일상 속 작은 기쁨과 행복을 발견하는 습관을 가져보세요',
    '끊임없이 배우고 성장하는 것이 인생을 풍요롭게 합니다',
    '함께 힘을 모으면 불가능해 보이는 일도 이룰 수 있습니다',
    '시간은 우리에게 주어진 가장 소중한 선물임을 잊지 마세요',
    '자신의 한계를 뛰어넘으려는 도전 정신이 우리를 성장시킵니다',
    '다른 사람의 성공을 진심으로 축하할 줄 아는 사람이 되세요',
    '좋은 친구는 인생의 가장 큰 축복 중 하나입니다',
    '매일 감사일기를 쓰면 더 행복한 삶을 살 수 있습니다',
    '작은 변화들이 모여 큰 혁신을 이룰 수 있다는 것을 믿으세요',
    '꿈을 향해 한 걸음씩 나아가는 용기가 필요합니다',
    '남을 판단하기 전에 자신을 돌아보는 습관을 가지세요',
    '긍정적인 에너지는 주변 사람들에게도 전달됩니다',
    '평생 학습자의 자세로 살아가면 인생이 더욱 풍요로워집니다',
    '작은 성공의 경험들이 모여 큰 자신감을 만듭니다',
    '타인의 입장에서 생각해보는 연습을 매일 해보세요',
    '자신의 가치를 알고 그에 맞는 삶을 살아가는 것이 중요합니다',
    '어려운 결정 앞에서도 항상 정직하고 성실한 태도를 지키세요',
    '매일 조금씩 운동하는 습관이 건강한 삶의 기초가 됩니다',
    '꾸준히 독서하는 습관은 지식과 지혜를 쌓는 좋은 방법입니다',
    '다른 사람의 장점을 발견하고 칭찬하는 습관을 가져보세요',
    '스트레스 관리는 행복하고 건강한 삶을 위해 꼭 필요합니다',
    '어려운 시기를 겪을 때 가족의 소중함을 더 깊이 느낍니다',
    '자신의 감정 솔직하게 표현하는 것도 중요한 능력입니다',
    '작은 목표를 세우고 달성해 나가면서 성취감을 느껴보세요',
    '타인의 의견을 경청하는 자세가 좋은 관계의 시작입니다',
    '자신의 직업에 자부심을 갖고 최선을 다하는 것이 중요합니다',
    '새로운 도전 앞에서 두려워하지 말고 용기를 내보세요',
    '인내심을 갖고 꾸준히 노력하면 원하는 목표를 이룰 수 있습니다',
    '다른 사람의 아이디어를 존중하고 배우는 자세가 필요합니다',
    '자신의 실수를 인정하고 배우는 것이 성장의 지름길입니다',
    '작은 선행이 모여 세상을 변화시킬 수 있다는 것을 믿으세요',
    '매일 새로운 것을 배우려는 호기심을 잃지 마세요',
    '타인을 배려하는 마음이 더 나은 세상을 만듭니다',
    '자신의 장점을 발견하고 그것을 발전시키는 것이 중요합니다',
    '어려운 상황에서도 유머 감각을 잃지 않는 것이 도움이 됩니다',
    '규칙적인 생활 습관이 건강하고 생산적인 삶의 기초입니다',
    '다른 사람의 이야기에 귀 기울이는 습관을 가져보세요',
    '자신의 꿈을 위해 지금 당장 할 수 있는 일부터 시작하세요',
    '타인의 성공 스토리에서 영감을 얻고 동기 부여를 받으세요',
    '매일 조금씩 자신을 개선하려는 노력이 큰 변화를 만듭니다',
    '긍정적인 자기 대화는 자신감과 성취감을 여���다',
    '다양한 경험을 통해 자신의 잠재력을 발견할 수 있습니다',
    '타인의 의견을 존중하면서도 자신의 신념을 지키는 것이 중요합니다',
    '실패를 두려워하지 말고 그것을 배움의 기회로 삼으세요',
    '매일 작은 감사 거리를 찾는 습관이 행복을 가져다 줍니다',
    '자신의 감정을 잘 다스리는 것이 성공의 중요한 요소입니다',
    '새로운 도전은 우리를 성장시키고 삶을 풍요롭게 합니다',
    '다른 사람의 눈높이에 맞춰 소통하는 능력을 기르세요',
    '자신의 가치관에 따라 일관성 있게 살아가는 것이 중요합니다',
    '어려운 결정을 내릴 때는 직관과 이성의 균형을 잡으세요',
    '타인의 단점보다는 장점에 초점을 맞추는 습관을 가지세요',
    '자신의 행복은 스스로 만들어 가는 것임을 기억하세요',
    '새로운 아이디어에 열린 마음을 가지고 접근해 보세요',
    '꾸준한 노력이 재능보다 더 중요하다는 것을 믿으세요',
    '다른 사람의 생각을 존중하면서도 자신의 의견을 표현하세요',
    '자신의 건강을 위해 규칙적인 생활 습관을 만들어 보세요',
    '어려운 상황에서도 긍정적인 면을 찾으려고 노력세요',
    '타인을 돕는 과정에서 자신도 성장할 수 있음을 기억하세요',
    '자신의 직관을 믿고 그에 따라 행동하는 용기를 가지세요',
    '새로운 기술을 배우 것은 미래를 위한 투자입니다',
    '다양한 문화를 이해하고 존중하는 태도를 갖추세요',
    '자신의 감정을 솔직하게 표현하되 상대방을 배려하세요',
    '어려운 시기를 겪을 때 주변의 도움을 받아들이세요',
    '타인의 성공을 시기하지 말고 함께 기뻐하는 마음을 가지세요',
    '자신의 한계를 극복하려는 노력이 우리를 성장시킵니다',
    '새로운 관점으로 문제를 바라보면 해결책이 보일 수 있습니다',
    '다른 사람의 비판을 두려워하지 말고 그것에서 배우세요',
    '자신의 실수를 인정하고 개선하려는 태도가 중요합니다',
    '어려운 결정 앞에서도 자신의 가치관을 지키는 것이 중요합니다',
    '타인의 감정을 이해하고 공감하는 능력을 키워보세요',
    '자신의 열정을 찾고 그것을 위해 노력하는 삶을 살아가세요',
    '새로운 도전을 통해 자신의 한계를 어넘어 보세요',
    '다양한 경험이 우리의 시야를 넓히고 성장시킵니다',
    '자신의 강점을 발견하고 그것을 활용하는 방법을 찾아보세요',
    '어려운 상황에서도 희망을 잃지 않는 것이 중요합니다',
    '타인의 장점을 배우고 자신의 것으로 만들어 보세요',
    '자신의 행동에 책임을 지는 성숙한 태도가 필요합니다',
    '새로운 지식을 얻는 것에 대한 열정을 잃지 마세요',
    '다른 사람의 입장에서 생각해 보는 연습을 해보세요',
    '자신의 감정을 잘 다스리는 것이 좋은 관계의 기초입니다',
    '어려운 시기를 극복한 후에 더 강해질 수 있습니다',
    '타인의 성공 스토리에서 배울 점을 찾아보세요',
    '자신의 꿈을 위해 구체적인 계획을 세우고 실천하세요',
    '새로운 환경에 적응하는 능력을 키우는 것이 중요합니다',
    '다양한 관점을 수용하는 열린 마음을 가지세요',
    '자신의 목표를 향해 꾸준히 노력하는 것이 성공의 비결입니다',
    '어려운 상황에서도 유머 감각을 잃지 않는 것이 도움이 됩니다',
    '타인의 의견을 존중하면서도 자신의 생각을 표현하세요',
    '자신의 실수를 인정하고 개선하려는 자세가 필요합니다',
    '새로운 기회를 찾는 눈을 항상 열어두는 것이 중요합니다',
    '다른 사람의 장점을 인정하고 배우려는 태도를 가지세요',
    '자신의 한계를 극복하려는 노력이 성장의 원동력입니다',
    '어려운 결정 앞에서도 정직과 성실을 잃지 마세요',
    '타인의 감정을 존중하고 배려하는 마음을 가지세요',
    '자신의 가치를 알고 그에 맞는 삶을 살아가세요',
    '새로운 아이디어를 실천에 옮기는 용기가 필요합니다',
    '다양한 경험을 통해 자신의 잠재력을 발견하세요',
    '자신의 감정을 솔직하게 표현하되 타인을 배려하세요',
    '어려운 시기를 겪을 때 주변 사람들의 도움을 받아들이세요',
    '타인의 성공을 축하해 줄 줄 아는 넓은 마음을 가지세요',
    '자신의 직관을 믿고 그에 따라 행동하는 용기를 가지세요',
    '새로운 기술을 배우 것은 미래를 위한 투자입니다',
    '다양한 문화를 이해하고 존중하는 태도를 갖추세요',
    '자신의 꿈을 향해 한 걸음씩 나아가는 인내심이 필요합니다',
    '어려운 상황에서도 긍정적인 마인드를 유지하세요',
    '타인의 입장에서 생각해 보는 습관을 들이세요',
    '자신의 강점을 발견하고 그것을 발전시키는 노력이 중요합니다',
    '새로운 도전을 두려워하지 말고 기회로 삼으세요',
    '다른 사람의 의견을 경청하고 배우려는 자세가 필요합니다',
    '자신의 행동에 책임을 지는 성숙한 태도를 가지세요',
    '어려운 결정을 내릴 때는 충분히 고민하고 결정하세요',
    '타인의 성공 스토리에서 영감을 얻고 동기를 부여받으세요',
    '자신의 가치관에 따라 일관성 있게 살아가는 것이 중요합니다',
    '새로운 지식을 습득하는 것에 대한 열정을 잃지 마세요',
    '다양한 관점을 수용하는 열린 마음을 가지세요',
    '자신의 목표를 위해 지금 당장 할 수 있는 일부터 시작하세요',
    '어려운 상황에서도 희망을 잃지 않는 것이 중요합니다',
    '타인의 장점을 배우고 자신의 것으로 만들어 보세요',
    '자신의 감정을 잘 다스리는 것이 성공의 중요한 요소입니다',
    '새로운 경험을 통해 자신의 시야를 넓혀보세요',
    '다른 사람의 비판을 두려워하지 말고 그것에서 배우세요',
    '자신의 실수를 인정하고 그것을 개선할 기회로 삼으세요',
    '어려운 시기를 겪을 때 자신을 돌아보는 시간을 가지세요',
    '타인의 의견을 존중하면서도 자신의 신념을 지키세요',
    '자신의 열정을 찾고 그것을 위해 노력하는 삶을 살아가세요',
    '새로운 아이디어에 열린 마음을 가지고 접근해 보세요',
    '다양한 경험이 우리의 시야를 넓히고 성장시킵니다',
    '자신의 한계를 뛰어넘으려는 도전 정신이 필요합니다',
    '어려운 상황에서도 유머 감각을 잃지 않는 것이 도움이 됩니다',
    '타인의 성공을 시기하지 말고 함께 기뻐하는 마음을 가지세요',
    '자신의 가치를 알고 그에 맞는 삶을 살아가는 것이 중요합니다',
  ];

  // static final List<String> _koreanSentences = [
  //   '나는 오늘 행복합니다',
  //   '꿈을 향해 달려갑니다',
  //   '세상은 아름답습니다',
  //   '하늘은 언제나 푸릅니다',
  //   '사랑하는 사람과 함께해요',
  //   '새로운 도전을 시작합니다',
  //   '지금 이 순간이 소중해요',
  //   '작은 기쁨에 감사합니다',
  //   '열심히 노력하면 됩니다',
  //   '우리는 하나로 뭉칩니다',
  //   '시간은 빠르게 흘러갑니다',
  //   '모든 것이 잘될 거예요',
  //   '친구와 함께 웃고 있어요',
  //   '가족의 사랑은 따뜻해요',
  //   '꿈은 반드시 이루어집니다',
  //   '책 속에 지혜가 있습니다',
  //   '음악은 마음의 양식입니다',
  //   '운동은 건강에 좋습니다',
  //   '여행은 삶의 활력소예요',
  //   '자연은 우리의 친구입니다',
  //   '미래는 밝고 희망찹니다',
  //   '노력하는 자가 성공합니다',
  //   '오늘 하루도 감사합니다',
  //   '새로운 인연을 만났습니다',
  //   '마음의 평화를 찾습니다',
  //   '계절의 변화가 아름답네요',
  //   '일상의 소중함을 느낍니다',
  //   '좋은 생각이 떠올랐어요',
  //   '행복은 가까이에 있습니다',
  //   '우리의 미래는 밝습니다',
  //   '항상 긍정적으로 생각해요',
  //   '좋은 습관을 만들어갑니다',
  //   '새로운 기술을 배웁니다',
  //   '다른 사람을 이해합니다',
  //   '매일 조금씩 성장합니다',
  //   '어려움을 극복할 수 있어요',
  //   '함께하면 더 강해집니다',
  //   '꾸준히 노력하면 됩니다',
  //   '마음을 열고 대화합니다',
  //   '작은 변화가 모여 큽니다',
  //   '오늘도 최선을 다합니다',
  //   '건강이 가장 중요합니다',
  //   '새로운 경험을 즐깁니다',
  //   '다양성을 인정합니다',
  //   '서로 돕고 나눕니다',
  //   '꿈을 포기하지 않습니다',
  //   '어제보다 나은 오늘입니다',
  //   '창의력을 발휘합니다',
  //   '모두가 평등한 세상입니다',
  //   '자신을 사랑해야 합니다',
  //   '좋은 인연에 감사합니다',
  //   '작은 기적을 만듭니다',
  //   '환경을 생각하며 살아요',
  //   '배움에는 끝이 없습니다',
  //   '서로 존중하며 살아갑니다',
  //   '긍정의 힘을 믿습니다',
  //   '오늘 하루를 즐깁니다',
  //   '내일은 더 좋을 거예요',
  //   '함께 웃으며 살아갑니다',
  //   '마음을 열고 경청합니다',
  //   '서로의 차이를 인정해요',
  //   '실패는 성공의 어머니예요',
  //   '도전은 우리를 성장시켜요',
  //   '꾸준함이 열매를 맺습니다',
  //   '작은 친절이 세상을 바꿔요',
  //   '서로 이해하고 배려합니다',
  //   '좋은 에너지가 넘칩니다',
  //   '새로운 기회가 찾아옵니다',
  //   '매일 감사일기를 씁니다',
  //   '긍정적인 말을 사용합니다',
  //   '자신감을 가지고 행동해요',
  //   '꿈을 현실로 만듭니다',
  //   '좋은 습관이 인생을 바꿔요',
  //   '건강한 몸과 마음을 가꿔요',
  //   '서로 응원하며 살아갑니다',
  //   '새로운 도전을 환영합니다',
  //   '함께 성장하는 기쁨입니다',
  //   '어려움 속에 기회가 있어요',
  //   '작은 성취를 축하합니다',
  //   '서로의 장점을 인정합니다',
  //   '매일 조금씩 발전합니다',
  //   '행복은 선택하는 것입니다',
  //   '좋은 생각이 좋은 삶을 만들어요',
  //   '희망을 잃지 않습니다',
  //   '서로 격려하며 살아갑니다',
  //   '새로운 시작을 환영합니다',
  //   '좋은 습관이 성공을 만들어요',
  //   '항상 감사하는 마음으로 살아요',
  //   '서로 돕는 사회를 만듭니다',
  //   '꿈을 향해 한 걸음 더 나아가요',
  //   '어려움은 지나갈 것입니다',
  //   '함께 나누는 삶이 풍요롭습니다',
  //   '매일 작은 기적을 만듭니다',
  //   '긍정적인 변화를 만듭니다',
  //   '서로의 성장을 응원합니다',
  //   '새로운 목표를 세웁니다',
  //   '행복은 지금 여기에 있습니다',
  //   '좋은 영향력을 전파합니다',
  //   '꾸준한 노력이 빛을 발합니다',
  //   '서로 신뢰하며 살아갑니다',
  //   '매일 감사할 것을 찾습니다',
  //   '긍정적인 미래를 그립니다',
  //   '함께 꿈을 이루어 갑니다',
  //   '작은 실천이 세상을 바꿔요',
  //   '서로의 재능을 인정합니다',
  // ];

  static String _generateRandomWord(String language, String mode) {
    if (mode == '단어') {
      if (language == '영어') {
        const letters = 'abcdefghijklmnopqrstuvwxyz';
        final random = Random();
        return String.fromCharCodes(Iterable.generate(5, (_) => letters.codeUnitAt(random.nextInt(letters.length))));
      } else {
        const syllables = '가나다라마바사아자차카타파하거너더러머버서어저처커터퍼허고노도로모보소오조초코토포호구누두루무부수우주추쿠투푸후';
        final random = Random();
        return String.fromCharCodes(Iterable.generate(2, (_) => syllables.codeUnitAt(random.nextInt(syllables.length))));
      }
    } else {
      if (language == '영어') {
        // 영어 문장 목록을 추가하고 여기서 랜덤으로 선택
        return "This is an English sentence.";
      } else {
        return _koreanSentences[Random().nextInt(_koreanSentences.length)];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _inputTextNotifier = ValueNotifier<String>('');
    _textController.addListener(_updateInputText);
    _loadSettings().then((_) {
      _resetTest();
    });
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mode = prefs.getString('mode') ?? '단어';
      _wordCount = prefs.getInt('wordCount') ?? 20;
      _language = prefs.getString('language') ?? '영어';
      _targetSpeed = prefs.getInt('targetSpeed') ?? 200;
    });
  }

  void _showSettingsPage() async {
    await Get.to(() => SettingsPage(
          onModeChanged: (String newMode) {
            setState(() {
              _mode = newMode;
              _resetTest();
            });
          },
          onWordCountChanged: (int newWordCount) {
            setState(() {
              _wordCount = newWordCount;
              _resetTest();
            });
          },
          onLanguageChanged: (String newLanguage) {
            setState(() {
              _language = newLanguage;
              _resetTest();
            });
          },
          onTargetSpeedChanged: (int newTargetSpeed) {
            setState(() {
              _targetSpeed = newTargetSpeed;
            });
          },
        ));
    _loadSettings();
  }

  @override
  void dispose() {
    _textController.removeListener(_updateInputText);
    _inputTextNotifier.dispose();
    _textController.dispose();
    _stopwatch.stop();
    _wordStopwatch.stop();
    _timer?.cancel();
    super.dispose();
  }

  void _updateInputText() {
    _inputTextNotifier.value = _textController.text;
  }

  void _startTimer() {
    if (!_isStarted) {
      _isStarted = true;
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {});
      });
    }
  }

  void _onTextChanged(String value) {
    if (!_isStarted) {
      _startTimer();
    }
    if (_currentWordIndex >= _words.length) {
      return;
    }

    String currentWord = _words[_currentWordIndex];

    if (_isNewWord && value.isNotEmpty) {
      _isNewWord = false;
      _isCurrentWordStarted = true;
      _wordStopwatch.reset();
      _wordStopwatch.start();
      _decomposedCurrentWord = decomposeKorean(currentWord);
    }

    _decomposedInput = decomposeKorean(value);

    int correctJamo = 0;
    int lastCorrectIndex = -1;

    for (int i = 0; i < _decomposedInput.length && i < _decomposedCurrentWord.length; i++) {
      if (_decomposedInput[i] == _decomposedCurrentWord[i]) {
        correctJamo++;
        lastCorrectIndex = i;
      }
    }

    _totalTypedCharacters = _decomposedInput.length;
    _correctCharacters = correctJamo;

    if (_isCurrentWordStarted) {
      double elapsedSeconds = _wordStopwatch.elapsedMilliseconds / 1000;

      // 마지막으로 정확하게 입력한 자모까지의 시간을 계산
      double correctElapsedSeconds = (lastCorrectIndex + 1) * elapsedSeconds / _decomposedInput.length;

      // 정확하게 입력한 자모 수에 대한 속도 계산
      _currentWordSpeed = (correctJamo * 60) / correctElapsedSeconds;
    }

    setState(() {}); // 상태 업데이트

    // 문장 모드일 때는 문장 길이만큼 입력되면 다음으로 넘어가도록 수정
    if (_mode == '문장') {
      if (_decomposedInput.length >= _decomposedCurrentWord.length) {
        _moveToNextWord(value);
      }
    } else {
      // 단어 모드일 때는 기존 로직 유지
      if (_decomposedInput.length >= _decomposedCurrentWord.length || value.endsWith(' ')) {
        _moveToNextWord(value);
      }
    }
  }

  void _moveToNextWord(String value) {
    int correctJamo = 0;
    for (int i = 0; i < _decomposedInput.length && i < _decomposedCurrentWord.length; i++) {
      if (_decomposedInput[i] == _decomposedCurrentWord[i]) {
        correctJamo++;
      }
    }

    if (correctJamo == _decomposedCurrentWord.length) {
      _totalCorrectWords++;
    } else {
      _totalErrorWords++;
    }

    _wordSpeeds.add(_currentWordSpeed);

    _textController.clear();
    _isCurrentWordStarted = false;
    _isNewWord = true;
    _decomposedInput.clear();
    _decomposedCurrentWord.clear();
    setState(() {
      _currentWordIndex++;
      if (_currentWordIndex >= _words.length) {
        _stopwatch.stop();
        _wordStopwatch.stop();
        _timer?.cancel();
        _showTestResults();
      }
    });
  }

  void _showTestResults() {
    showDialog(
      context: context,
      barrierDismissible: false, // 사용자가 다이얼로그 바깥을 터치해도 닫히지 않도록 설정
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('테스트 완료', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('정확도: ${(_totalCorrectWords / _words.length * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 20)),
            Text('평균 타이핑 속도: ${_averageTypingSpeed.toStringAsFixed(0)} 타/분', style: const TextStyle(color: Colors.white, fontSize: 20)),
            Text('오류율: ${(_errorRate * 100).toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
              _resetTest(); // 테스트 재설정
              setState(() {}); // UI 업데이트
            },
            child: const Text('확인', style: TextStyle(color: Color(0xFF4CAF50))),
          ),
        ],
      ),
    );
  }

  double get _averageTypingSpeed {
    if (_wordSpeeds.isEmpty) return 0;
    return _wordSpeeds.reduce((a, b) => a + b) / _wordSpeeds.length;
  }

  double get _errorRate {
    return _totalErrorWords / _words.length;
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              title: const Text('설정', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: _mode,
                    dropdownColor: const Color(0xFF2C2C2C),
                    items: ['단어', '문장'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _mode = newValue;
                        });
                      }
                    },
                  ),
                  DropdownButton<int>(
                    value: _wordCount,
                    dropdownColor: const Color(0xFF2C2C2C),
                    items: [10, 20, 30, 40, 50].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value ${_mode == '단어' ? '단어' : '문장'}', style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _wordCount = newValue;
                        });
                      }
                    },
                  ),
                  DropdownButton<String>(
                    value: _language,
                    dropdownColor: const Color(0xFF2C2C2C),
                    items: ['영어', '한국어'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _language = newValue;
                        });
                      }
                    },
                  ),
                  Text('목표 타수: $_targetSpeed 타/분', style: const TextStyle(color: Colors.white)),
                  Slider(
                    value: _targetSpeed.toDouble(),
                    min: 100,
                    max: 500,
                    divisions: 40,
                    label: _targetSpeed.round().toString(),
                    activeColor: const Color(0xFF4CAF50),
                    inactiveColor: const Color(0xFF2C2C2C),
                    onChanged: (double newValue) {
                      setState(() {
                        _targetSpeed = newValue.round();
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('취소', style: TextStyle(color: Color(0xFF4CAF50))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('확인', style: TextStyle(color: Color(0xFF4CAF50))),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetTest();
                    setState(() {});
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _resetTest() {
    setState(() {
      _words = List.generate(_wordCount, (index) => _generateRandomWord(_language, _mode));
      _currentWordIndex = 0;
      _totalErrorWords = 0;
      _totalCorrectWords = 0;
      _totalTypedCharacters = 0;
      _correctCharacters = 0;
      _wordSpeeds.clear();
      _currentWordSpeed = 0;
      _isCurrentWordStarted = false;
      _isNewWord = true;
      _isStarted = false;
      _stopwatch.reset();
      _wordStopwatch.reset();
      _timer?.cancel();
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: const Text(
          'Typing Test',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: _showSettingsPage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCurrentCount('$_currentWordIndex/${_words.length}', _currentWordIndex / _words.length),
            const SizedBox(height: 16),
            if (_currentWordIndex < _words.length) _buildCurrentWord(_words[_currentWordIndex]),
            const SizedBox(height: 16),
            _buildProgressBar('속도', _currentWordSpeed / 300, showSpeed: true),
            const SizedBox(height: 8),
            _buildProgressBar('오류율', _errorRate),
            const SizedBox(height: 16),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String title, double progress, {bool showSpeed = false}) {
    Color progressColor = const Color(0xFF4CAF50);
    String displayText;
    double displayProgress;

    if (title == 'Error Rate' || title == '오류율') {
      progressColor = const Color(0xFFE57373);
      displayText = '${(progress * 100).toStringAsFixed(1)}%';
      displayProgress = progress;
    } else {
      if (showSpeed) {
        double speed = _currentWordSpeed;
        displayText = '${speed.toStringAsFixed(0)} 타/분';
        displayProgress = (speed / _targetSpeed).clamp(0.0, 1.0); // _targetSpeed를 최대값으로 사용
      } else {
        displayText = '${(progress * 100).toStringAsFixed(1)}%';
        displayProgress = progress;
      }
    }

    return ProgressBar(
      title: title,
      progress: displayProgress,
      progressColor: progressColor,
      displayText: displayText,
      backgroundColor: const Color(0xFF2C2C2C),
      textColor: Colors.white,
    );
  }

  Widget _buildCurrentCount(String title, double progress) {
    return ProgressBar(
      title: title,
      progress: progress,
      progressColor: const Color(0xFF4CAF50),
      displayText: '$_currentWordIndex/${_words.length}',
      backgroundColor: const Color(0xFF2C2C2C),
      textColor: Colors.white,
    );
  }

  Widget _buildCurrentWord(String word) {
    return ValueListenableBuilder<String>(
      valueListenable: _inputTextNotifier,
      builder: (context, inputText, child) {
        List<TextSpan> textSpans = [];

        for (int i = 0; i < word.length; i++) {
          Color color = Colors.white;
          TextDecoration decoration = TextDecoration.none;

          if (i < inputText.length) {
            if (word[i] != inputText[i]) {
              color = Colors.red;
              decoration = TextDecoration.underline;
            } else {
              color = Colors.green;
            }
          }

          textSpans.add(TextSpan(
            text: word[i],
            style: TextStyle(
              color: color,
              fontSize: 36,
              decoration: decoration,
            ),
          ));
        }

        return Center(
          child: RichText(
            text: TextSpan(children: textSpans),
          ),
        );
      },
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _textController,
        onChanged: _onTextChanged,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          hintText: 'Type here',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
        ),
        cursorColor: const Color(0xFF4CAF50),
        textInputAction: TextInputAction.none, // 엔터 키의 기본 동작 비활성화
        onSubmitted: (_) {}, // 엔터 키 입력 시 아무 동작도 하지 않음
      ),
    );
  }
}

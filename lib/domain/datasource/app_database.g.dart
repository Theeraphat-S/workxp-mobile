// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HeroesTable extends Heroes with TableInfo<$HeroesTable, Hero> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeroesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Arthur'),
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _currentExpMeta = const VerificationMeta(
    'currentExp',
  );
  @override
  late final GeneratedColumn<int> currentExp = GeneratedColumn<int>(
    'current_exp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hpMeta = const VerificationMeta('hp');
  @override
  late final GeneratedColumn<int> hp = GeneratedColumn<int>(
    'hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _maxHpMeta = const VerificationMeta('maxHp');
  @override
  late final GeneratedColumn<int> maxHp = GeneratedColumn<int>(
    'max_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _mpMeta = const VerificationMeta('mp');
  @override
  late final GeneratedColumn<int> mp = GeneratedColumn<int>(
    'mp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _maxMpMeta = const VerificationMeta('maxMp');
  @override
  late final GeneratedColumn<int> maxMp = GeneratedColumn<int>(
    'max_mp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _coinsMeta = const VerificationMeta('coins');
  @override
  late final GeneratedColumn<int> coins = GeneratedColumn<int>(
    'coins',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _strMeta = const VerificationMeta('str');
  @override
  late final GeneratedColumn<int> str = GeneratedColumn<int>(
    'str',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _agiMeta = const VerificationMeta('agi');
  @override
  late final GeneratedColumn<int> agi = GeneratedColumn<int>(
    'agi',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _intAttrMeta = const VerificationMeta(
    'intAttr',
  );
  @override
  late final GeneratedColumn<int> intAttr = GeneratedColumn<int>(
    'int_attr',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _vitMeta = const VerificationMeta('vit');
  @override
  late final GeneratedColumn<int> vit = GeneratedColumn<int>(
    'vit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _unspentStatPointsMeta = const VerificationMeta(
    'unspentStatPoints',
  );
  @override
  late final GeneratedColumn<int> unspentStatPoints = GeneratedColumn<int>(
    'unspent_stat_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isGhostMeta = const VerificationMeta(
    'isGhost',
  );
  @override
  late final GeneratedColumn<bool> isGhost = GeneratedColumn<bool>(
    'is_ghost',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ghost" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activeTitleMeta = const VerificationMeta(
    'activeTitle',
  );
  @override
  late final GeneratedColumn<String> activeTitle = GeneratedColumn<String>(
    'active_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Novice Adventurer'),
  );
  static const VerificationMeta _avatarSkinIdMeta = const VerificationMeta(
    'avatarSkinId',
  );
  @override
  late final GeneratedColumn<String> avatarSkinId = GeneratedColumn<String>(
    'avatar_skin_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hero_novice'),
  );
  static const VerificationMeta _bannerIdMeta = const VerificationMeta(
    'bannerId',
  );
  @override
  late final GeneratedColumn<String> bannerId = GeneratedColumn<String>(
    'banner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('default_banner'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    level,
    currentExp,
    hp,
    maxHp,
    mp,
    maxMp,
    coins,
    str,
    agi,
    intAttr,
    vit,
    unspentStatPoints,
    isGhost,
    activeTitle,
    avatarSkinId,
    bannerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'heroes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Hero> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('current_exp')) {
      context.handle(
        _currentExpMeta,
        currentExp.isAcceptableOrUnknown(data['current_exp']!, _currentExpMeta),
      );
    }
    if (data.containsKey('hp')) {
      context.handle(_hpMeta, hp.isAcceptableOrUnknown(data['hp']!, _hpMeta));
    }
    if (data.containsKey('max_hp')) {
      context.handle(
        _maxHpMeta,
        maxHp.isAcceptableOrUnknown(data['max_hp']!, _maxHpMeta),
      );
    }
    if (data.containsKey('mp')) {
      context.handle(_mpMeta, mp.isAcceptableOrUnknown(data['mp']!, _mpMeta));
    }
    if (data.containsKey('max_mp')) {
      context.handle(
        _maxMpMeta,
        maxMp.isAcceptableOrUnknown(data['max_mp']!, _maxMpMeta),
      );
    }
    if (data.containsKey('coins')) {
      context.handle(
        _coinsMeta,
        coins.isAcceptableOrUnknown(data['coins']!, _coinsMeta),
      );
    }
    if (data.containsKey('str')) {
      context.handle(
        _strMeta,
        str.isAcceptableOrUnknown(data['str']!, _strMeta),
      );
    }
    if (data.containsKey('agi')) {
      context.handle(
        _agiMeta,
        agi.isAcceptableOrUnknown(data['agi']!, _agiMeta),
      );
    }
    if (data.containsKey('int_attr')) {
      context.handle(
        _intAttrMeta,
        intAttr.isAcceptableOrUnknown(data['int_attr']!, _intAttrMeta),
      );
    }
    if (data.containsKey('vit')) {
      context.handle(
        _vitMeta,
        vit.isAcceptableOrUnknown(data['vit']!, _vitMeta),
      );
    }
    if (data.containsKey('unspent_stat_points')) {
      context.handle(
        _unspentStatPointsMeta,
        unspentStatPoints.isAcceptableOrUnknown(
          data['unspent_stat_points']!,
          _unspentStatPointsMeta,
        ),
      );
    }
    if (data.containsKey('is_ghost')) {
      context.handle(
        _isGhostMeta,
        isGhost.isAcceptableOrUnknown(data['is_ghost']!, _isGhostMeta),
      );
    }
    if (data.containsKey('active_title')) {
      context.handle(
        _activeTitleMeta,
        activeTitle.isAcceptableOrUnknown(
          data['active_title']!,
          _activeTitleMeta,
        ),
      );
    }
    if (data.containsKey('avatar_skin_id')) {
      context.handle(
        _avatarSkinIdMeta,
        avatarSkinId.isAcceptableOrUnknown(
          data['avatar_skin_id']!,
          _avatarSkinIdMeta,
        ),
      );
    }
    if (data.containsKey('banner_id')) {
      context.handle(
        _bannerIdMeta,
        bannerId.isAcceptableOrUnknown(data['banner_id']!, _bannerIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hero map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hero(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      currentExp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_exp'],
      )!,
      hp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hp'],
      )!,
      maxHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_hp'],
      )!,
      mp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mp'],
      )!,
      maxMp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_mp'],
      )!,
      coins: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coins'],
      )!,
      str: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}str'],
      )!,
      agi: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}agi'],
      )!,
      intAttr: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}int_attr'],
      )!,
      vit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vit'],
      )!,
      unspentStatPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unspent_stat_points'],
      )!,
      isGhost: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ghost'],
      )!,
      activeTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_title'],
      )!,
      avatarSkinId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_skin_id'],
      )!,
      bannerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}banner_id'],
      )!,
    );
  }

  @override
  $HeroesTable createAlias(String alias) {
    return $HeroesTable(attachedDatabase, alias);
  }
}

class Hero extends DataClass implements Insertable<Hero> {
  final String id;
  final String name;
  final int level;
  final int currentExp;
  final int hp;
  final int maxHp;
  final int mp;
  final int maxMp;
  final int coins;
  final int str;
  final int agi;
  final int intAttr;
  final int vit;
  final int unspentStatPoints;
  final bool isGhost;
  final String activeTitle;
  final String avatarSkinId;
  final String bannerId;
  const Hero({
    required this.id,
    required this.name,
    required this.level,
    required this.currentExp,
    required this.hp,
    required this.maxHp,
    required this.mp,
    required this.maxMp,
    required this.coins,
    required this.str,
    required this.agi,
    required this.intAttr,
    required this.vit,
    required this.unspentStatPoints,
    required this.isGhost,
    required this.activeTitle,
    required this.avatarSkinId,
    required this.bannerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['level'] = Variable<int>(level);
    map['current_exp'] = Variable<int>(currentExp);
    map['hp'] = Variable<int>(hp);
    map['max_hp'] = Variable<int>(maxHp);
    map['mp'] = Variable<int>(mp);
    map['max_mp'] = Variable<int>(maxMp);
    map['coins'] = Variable<int>(coins);
    map['str'] = Variable<int>(str);
    map['agi'] = Variable<int>(agi);
    map['int_attr'] = Variable<int>(intAttr);
    map['vit'] = Variable<int>(vit);
    map['unspent_stat_points'] = Variable<int>(unspentStatPoints);
    map['is_ghost'] = Variable<bool>(isGhost);
    map['active_title'] = Variable<String>(activeTitle);
    map['avatar_skin_id'] = Variable<String>(avatarSkinId);
    map['banner_id'] = Variable<String>(bannerId);
    return map;
  }

  HeroesCompanion toCompanion(bool nullToAbsent) {
    return HeroesCompanion(
      id: Value(id),
      name: Value(name),
      level: Value(level),
      currentExp: Value(currentExp),
      hp: Value(hp),
      maxHp: Value(maxHp),
      mp: Value(mp),
      maxMp: Value(maxMp),
      coins: Value(coins),
      str: Value(str),
      agi: Value(agi),
      intAttr: Value(intAttr),
      vit: Value(vit),
      unspentStatPoints: Value(unspentStatPoints),
      isGhost: Value(isGhost),
      activeTitle: Value(activeTitle),
      avatarSkinId: Value(avatarSkinId),
      bannerId: Value(bannerId),
    );
  }

  factory Hero.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hero(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      level: serializer.fromJson<int>(json['level']),
      currentExp: serializer.fromJson<int>(json['currentExp']),
      hp: serializer.fromJson<int>(json['hp']),
      maxHp: serializer.fromJson<int>(json['maxHp']),
      mp: serializer.fromJson<int>(json['mp']),
      maxMp: serializer.fromJson<int>(json['maxMp']),
      coins: serializer.fromJson<int>(json['coins']),
      str: serializer.fromJson<int>(json['str']),
      agi: serializer.fromJson<int>(json['agi']),
      intAttr: serializer.fromJson<int>(json['intAttr']),
      vit: serializer.fromJson<int>(json['vit']),
      unspentStatPoints: serializer.fromJson<int>(json['unspentStatPoints']),
      isGhost: serializer.fromJson<bool>(json['isGhost']),
      activeTitle: serializer.fromJson<String>(json['activeTitle']),
      avatarSkinId: serializer.fromJson<String>(json['avatarSkinId']),
      bannerId: serializer.fromJson<String>(json['bannerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'level': serializer.toJson<int>(level),
      'currentExp': serializer.toJson<int>(currentExp),
      'hp': serializer.toJson<int>(hp),
      'maxHp': serializer.toJson<int>(maxHp),
      'mp': serializer.toJson<int>(mp),
      'maxMp': serializer.toJson<int>(maxMp),
      'coins': serializer.toJson<int>(coins),
      'str': serializer.toJson<int>(str),
      'agi': serializer.toJson<int>(agi),
      'intAttr': serializer.toJson<int>(intAttr),
      'vit': serializer.toJson<int>(vit),
      'unspentStatPoints': serializer.toJson<int>(unspentStatPoints),
      'isGhost': serializer.toJson<bool>(isGhost),
      'activeTitle': serializer.toJson<String>(activeTitle),
      'avatarSkinId': serializer.toJson<String>(avatarSkinId),
      'bannerId': serializer.toJson<String>(bannerId),
    };
  }

  Hero copyWith({
    String? id,
    String? name,
    int? level,
    int? currentExp,
    int? hp,
    int? maxHp,
    int? mp,
    int? maxMp,
    int? coins,
    int? str,
    int? agi,
    int? intAttr,
    int? vit,
    int? unspentStatPoints,
    bool? isGhost,
    String? activeTitle,
    String? avatarSkinId,
    String? bannerId,
  }) => Hero(
    id: id ?? this.id,
    name: name ?? this.name,
    level: level ?? this.level,
    currentExp: currentExp ?? this.currentExp,
    hp: hp ?? this.hp,
    maxHp: maxHp ?? this.maxHp,
    mp: mp ?? this.mp,
    maxMp: maxMp ?? this.maxMp,
    coins: coins ?? this.coins,
    str: str ?? this.str,
    agi: agi ?? this.agi,
    intAttr: intAttr ?? this.intAttr,
    vit: vit ?? this.vit,
    unspentStatPoints: unspentStatPoints ?? this.unspentStatPoints,
    isGhost: isGhost ?? this.isGhost,
    activeTitle: activeTitle ?? this.activeTitle,
    avatarSkinId: avatarSkinId ?? this.avatarSkinId,
    bannerId: bannerId ?? this.bannerId,
  );
  Hero copyWithCompanion(HeroesCompanion data) {
    return Hero(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      level: data.level.present ? data.level.value : this.level,
      currentExp: data.currentExp.present
          ? data.currentExp.value
          : this.currentExp,
      hp: data.hp.present ? data.hp.value : this.hp,
      maxHp: data.maxHp.present ? data.maxHp.value : this.maxHp,
      mp: data.mp.present ? data.mp.value : this.mp,
      maxMp: data.maxMp.present ? data.maxMp.value : this.maxMp,
      coins: data.coins.present ? data.coins.value : this.coins,
      str: data.str.present ? data.str.value : this.str,
      agi: data.agi.present ? data.agi.value : this.agi,
      intAttr: data.intAttr.present ? data.intAttr.value : this.intAttr,
      vit: data.vit.present ? data.vit.value : this.vit,
      unspentStatPoints: data.unspentStatPoints.present
          ? data.unspentStatPoints.value
          : this.unspentStatPoints,
      isGhost: data.isGhost.present ? data.isGhost.value : this.isGhost,
      activeTitle: data.activeTitle.present
          ? data.activeTitle.value
          : this.activeTitle,
      avatarSkinId: data.avatarSkinId.present
          ? data.avatarSkinId.value
          : this.avatarSkinId,
      bannerId: data.bannerId.present ? data.bannerId.value : this.bannerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hero(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('currentExp: $currentExp, ')
          ..write('hp: $hp, ')
          ..write('maxHp: $maxHp, ')
          ..write('mp: $mp, ')
          ..write('maxMp: $maxMp, ')
          ..write('coins: $coins, ')
          ..write('str: $str, ')
          ..write('agi: $agi, ')
          ..write('intAttr: $intAttr, ')
          ..write('vit: $vit, ')
          ..write('unspentStatPoints: $unspentStatPoints, ')
          ..write('isGhost: $isGhost, ')
          ..write('activeTitle: $activeTitle, ')
          ..write('avatarSkinId: $avatarSkinId, ')
          ..write('bannerId: $bannerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    level,
    currentExp,
    hp,
    maxHp,
    mp,
    maxMp,
    coins,
    str,
    agi,
    intAttr,
    vit,
    unspentStatPoints,
    isGhost,
    activeTitle,
    avatarSkinId,
    bannerId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hero &&
          other.id == this.id &&
          other.name == this.name &&
          other.level == this.level &&
          other.currentExp == this.currentExp &&
          other.hp == this.hp &&
          other.maxHp == this.maxHp &&
          other.mp == this.mp &&
          other.maxMp == this.maxMp &&
          other.coins == this.coins &&
          other.str == this.str &&
          other.agi == this.agi &&
          other.intAttr == this.intAttr &&
          other.vit == this.vit &&
          other.unspentStatPoints == this.unspentStatPoints &&
          other.isGhost == this.isGhost &&
          other.activeTitle == this.activeTitle &&
          other.avatarSkinId == this.avatarSkinId &&
          other.bannerId == this.bannerId);
}

class HeroesCompanion extends UpdateCompanion<Hero> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> level;
  final Value<int> currentExp;
  final Value<int> hp;
  final Value<int> maxHp;
  final Value<int> mp;
  final Value<int> maxMp;
  final Value<int> coins;
  final Value<int> str;
  final Value<int> agi;
  final Value<int> intAttr;
  final Value<int> vit;
  final Value<int> unspentStatPoints;
  final Value<bool> isGhost;
  final Value<String> activeTitle;
  final Value<String> avatarSkinId;
  final Value<String> bannerId;
  final Value<int> rowid;
  const HeroesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.currentExp = const Value.absent(),
    this.hp = const Value.absent(),
    this.maxHp = const Value.absent(),
    this.mp = const Value.absent(),
    this.maxMp = const Value.absent(),
    this.coins = const Value.absent(),
    this.str = const Value.absent(),
    this.agi = const Value.absent(),
    this.intAttr = const Value.absent(),
    this.vit = const Value.absent(),
    this.unspentStatPoints = const Value.absent(),
    this.isGhost = const Value.absent(),
    this.activeTitle = const Value.absent(),
    this.avatarSkinId = const Value.absent(),
    this.bannerId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HeroesCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.level = const Value.absent(),
    this.currentExp = const Value.absent(),
    this.hp = const Value.absent(),
    this.maxHp = const Value.absent(),
    this.mp = const Value.absent(),
    this.maxMp = const Value.absent(),
    this.coins = const Value.absent(),
    this.str = const Value.absent(),
    this.agi = const Value.absent(),
    this.intAttr = const Value.absent(),
    this.vit = const Value.absent(),
    this.unspentStatPoints = const Value.absent(),
    this.isGhost = const Value.absent(),
    this.activeTitle = const Value.absent(),
    this.avatarSkinId = const Value.absent(),
    this.bannerId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Hero> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? level,
    Expression<int>? currentExp,
    Expression<int>? hp,
    Expression<int>? maxHp,
    Expression<int>? mp,
    Expression<int>? maxMp,
    Expression<int>? coins,
    Expression<int>? str,
    Expression<int>? agi,
    Expression<int>? intAttr,
    Expression<int>? vit,
    Expression<int>? unspentStatPoints,
    Expression<bool>? isGhost,
    Expression<String>? activeTitle,
    Expression<String>? avatarSkinId,
    Expression<String>? bannerId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (level != null) 'level': level,
      if (currentExp != null) 'current_exp': currentExp,
      if (hp != null) 'hp': hp,
      if (maxHp != null) 'max_hp': maxHp,
      if (mp != null) 'mp': mp,
      if (maxMp != null) 'max_mp': maxMp,
      if (coins != null) 'coins': coins,
      if (str != null) 'str': str,
      if (agi != null) 'agi': agi,
      if (intAttr != null) 'int_attr': intAttr,
      if (vit != null) 'vit': vit,
      if (unspentStatPoints != null) 'unspent_stat_points': unspentStatPoints,
      if (isGhost != null) 'is_ghost': isGhost,
      if (activeTitle != null) 'active_title': activeTitle,
      if (avatarSkinId != null) 'avatar_skin_id': avatarSkinId,
      if (bannerId != null) 'banner_id': bannerId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HeroesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? level,
    Value<int>? currentExp,
    Value<int>? hp,
    Value<int>? maxHp,
    Value<int>? mp,
    Value<int>? maxMp,
    Value<int>? coins,
    Value<int>? str,
    Value<int>? agi,
    Value<int>? intAttr,
    Value<int>? vit,
    Value<int>? unspentStatPoints,
    Value<bool>? isGhost,
    Value<String>? activeTitle,
    Value<String>? avatarSkinId,
    Value<String>? bannerId,
    Value<int>? rowid,
  }) {
    return HeroesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      hp: hp ?? this.hp,
      maxHp: maxHp ?? this.maxHp,
      mp: mp ?? this.mp,
      maxMp: maxMp ?? this.maxMp,
      coins: coins ?? this.coins,
      str: str ?? this.str,
      agi: agi ?? this.agi,
      intAttr: intAttr ?? this.intAttr,
      vit: vit ?? this.vit,
      unspentStatPoints: unspentStatPoints ?? this.unspentStatPoints,
      isGhost: isGhost ?? this.isGhost,
      activeTitle: activeTitle ?? this.activeTitle,
      avatarSkinId: avatarSkinId ?? this.avatarSkinId,
      bannerId: bannerId ?? this.bannerId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (currentExp.present) {
      map['current_exp'] = Variable<int>(currentExp.value);
    }
    if (hp.present) {
      map['hp'] = Variable<int>(hp.value);
    }
    if (maxHp.present) {
      map['max_hp'] = Variable<int>(maxHp.value);
    }
    if (mp.present) {
      map['mp'] = Variable<int>(mp.value);
    }
    if (maxMp.present) {
      map['max_mp'] = Variable<int>(maxMp.value);
    }
    if (coins.present) {
      map['coins'] = Variable<int>(coins.value);
    }
    if (str.present) {
      map['str'] = Variable<int>(str.value);
    }
    if (agi.present) {
      map['agi'] = Variable<int>(agi.value);
    }
    if (intAttr.present) {
      map['int_attr'] = Variable<int>(intAttr.value);
    }
    if (vit.present) {
      map['vit'] = Variable<int>(vit.value);
    }
    if (unspentStatPoints.present) {
      map['unspent_stat_points'] = Variable<int>(unspentStatPoints.value);
    }
    if (isGhost.present) {
      map['is_ghost'] = Variable<bool>(isGhost.value);
    }
    if (activeTitle.present) {
      map['active_title'] = Variable<String>(activeTitle.value);
    }
    if (avatarSkinId.present) {
      map['avatar_skin_id'] = Variable<String>(avatarSkinId.value);
    }
    if (bannerId.present) {
      map['banner_id'] = Variable<String>(bannerId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeroesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('level: $level, ')
          ..write('currentExp: $currentExp, ')
          ..write('hp: $hp, ')
          ..write('maxHp: $maxHp, ')
          ..write('mp: $mp, ')
          ..write('maxMp: $maxMp, ')
          ..write('coins: $coins, ')
          ..write('str: $str, ')
          ..write('agi: $agi, ')
          ..write('intAttr: $intAttr, ')
          ..write('vit: $vit, ')
          ..write('unspentStatPoints: $unspentStatPoints, ')
          ..write('isGhost: $isGhost, ')
          ..write('activeTitle: $activeTitle, ')
          ..write('avatarSkinId: $avatarSkinId, ')
          ..write('bannerId: $bannerId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BossesTable extends Bosses with TableInfo<$BossesTable, Boss> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BossesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterMeta = const VerificationMeta(
    'chapter',
  );
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
    'chapter',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxHpMeta = const VerificationMeta('maxHp');
  @override
  late final GeneratedColumn<int> maxHp = GeneratedColumn<int>(
    'max_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentHpMeta = const VerificationMeta(
    'currentHp',
  );
  @override
  late final GeneratedColumn<int> currentHp = GeneratedColumn<int>(
    'current_hp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconAssetMeta = const VerificationMeta(
    'iconAsset',
  );
  @override
  late final GeneratedColumn<String> iconAsset = GeneratedColumn<String>(
    'icon_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDefeatedMeta = const VerificationMeta(
    'isDefeated',
  );
  @override
  late final GeneratedColumn<bool> isDefeated = GeneratedColumn<bool>(
    'is_defeated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_defeated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    chapter,
    maxHp,
    currentHp,
    iconAsset,
    isDefeated,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bosses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Boss> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(
        _chapterMeta,
        chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('max_hp')) {
      context.handle(
        _maxHpMeta,
        maxHp.isAcceptableOrUnknown(data['max_hp']!, _maxHpMeta),
      );
    } else if (isInserting) {
      context.missing(_maxHpMeta);
    }
    if (data.containsKey('current_hp')) {
      context.handle(
        _currentHpMeta,
        currentHp.isAcceptableOrUnknown(data['current_hp']!, _currentHpMeta),
      );
    } else if (isInserting) {
      context.missing(_currentHpMeta);
    }
    if (data.containsKey('icon_asset')) {
      context.handle(
        _iconAssetMeta,
        iconAsset.isAcceptableOrUnknown(data['icon_asset']!, _iconAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_iconAssetMeta);
    }
    if (data.containsKey('is_defeated')) {
      context.handle(
        _isDefeatedMeta,
        isDefeated.isAcceptableOrUnknown(data['is_defeated']!, _isDefeatedMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Boss map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Boss(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      chapter: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter'],
      )!,
      maxHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_hp'],
      )!,
      currentHp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_hp'],
      )!,
      iconAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_asset'],
      )!,
      isDefeated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_defeated'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $BossesTable createAlias(String alias) {
    return $BossesTable(attachedDatabase, alias);
  }
}

class Boss extends DataClass implements Insertable<Boss> {
  final String id;
  final String name;
  final int chapter;
  final int maxHp;
  final int currentHp;
  final String iconAsset;
  final bool isDefeated;
  final bool isActive;
  const Boss({
    required this.id,
    required this.name,
    required this.chapter,
    required this.maxHp,
    required this.currentHp,
    required this.iconAsset,
    required this.isDefeated,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['chapter'] = Variable<int>(chapter);
    map['max_hp'] = Variable<int>(maxHp);
    map['current_hp'] = Variable<int>(currentHp);
    map['icon_asset'] = Variable<String>(iconAsset);
    map['is_defeated'] = Variable<bool>(isDefeated);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  BossesCompanion toCompanion(bool nullToAbsent) {
    return BossesCompanion(
      id: Value(id),
      name: Value(name),
      chapter: Value(chapter),
      maxHp: Value(maxHp),
      currentHp: Value(currentHp),
      iconAsset: Value(iconAsset),
      isDefeated: Value(isDefeated),
      isActive: Value(isActive),
    );
  }

  factory Boss.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Boss(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      chapter: serializer.fromJson<int>(json['chapter']),
      maxHp: serializer.fromJson<int>(json['maxHp']),
      currentHp: serializer.fromJson<int>(json['currentHp']),
      iconAsset: serializer.fromJson<String>(json['iconAsset']),
      isDefeated: serializer.fromJson<bool>(json['isDefeated']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'chapter': serializer.toJson<int>(chapter),
      'maxHp': serializer.toJson<int>(maxHp),
      'currentHp': serializer.toJson<int>(currentHp),
      'iconAsset': serializer.toJson<String>(iconAsset),
      'isDefeated': serializer.toJson<bool>(isDefeated),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Boss copyWith({
    String? id,
    String? name,
    int? chapter,
    int? maxHp,
    int? currentHp,
    String? iconAsset,
    bool? isDefeated,
    bool? isActive,
  }) => Boss(
    id: id ?? this.id,
    name: name ?? this.name,
    chapter: chapter ?? this.chapter,
    maxHp: maxHp ?? this.maxHp,
    currentHp: currentHp ?? this.currentHp,
    iconAsset: iconAsset ?? this.iconAsset,
    isDefeated: isDefeated ?? this.isDefeated,
    isActive: isActive ?? this.isActive,
  );
  Boss copyWithCompanion(BossesCompanion data) {
    return Boss(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      maxHp: data.maxHp.present ? data.maxHp.value : this.maxHp,
      currentHp: data.currentHp.present ? data.currentHp.value : this.currentHp,
      iconAsset: data.iconAsset.present ? data.iconAsset.value : this.iconAsset,
      isDefeated: data.isDefeated.present
          ? data.isDefeated.value
          : this.isDefeated,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Boss(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('chapter: $chapter, ')
          ..write('maxHp: $maxHp, ')
          ..write('currentHp: $currentHp, ')
          ..write('iconAsset: $iconAsset, ')
          ..write('isDefeated: $isDefeated, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    chapter,
    maxHp,
    currentHp,
    iconAsset,
    isDefeated,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Boss &&
          other.id == this.id &&
          other.name == this.name &&
          other.chapter == this.chapter &&
          other.maxHp == this.maxHp &&
          other.currentHp == this.currentHp &&
          other.iconAsset == this.iconAsset &&
          other.isDefeated == this.isDefeated &&
          other.isActive == this.isActive);
}

class BossesCompanion extends UpdateCompanion<Boss> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> chapter;
  final Value<int> maxHp;
  final Value<int> currentHp;
  final Value<String> iconAsset;
  final Value<bool> isDefeated;
  final Value<bool> isActive;
  final Value<int> rowid;
  const BossesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.chapter = const Value.absent(),
    this.maxHp = const Value.absent(),
    this.currentHp = const Value.absent(),
    this.iconAsset = const Value.absent(),
    this.isDefeated = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BossesCompanion.insert({
    required String id,
    required String name,
    required int chapter,
    required int maxHp,
    required int currentHp,
    required String iconAsset,
    this.isDefeated = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       chapter = Value(chapter),
       maxHp = Value(maxHp),
       currentHp = Value(currentHp),
       iconAsset = Value(iconAsset);
  static Insertable<Boss> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? chapter,
    Expression<int>? maxHp,
    Expression<int>? currentHp,
    Expression<String>? iconAsset,
    Expression<bool>? isDefeated,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (chapter != null) 'chapter': chapter,
      if (maxHp != null) 'max_hp': maxHp,
      if (currentHp != null) 'current_hp': currentHp,
      if (iconAsset != null) 'icon_asset': iconAsset,
      if (isDefeated != null) 'is_defeated': isDefeated,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BossesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? chapter,
    Value<int>? maxHp,
    Value<int>? currentHp,
    Value<String>? iconAsset,
    Value<bool>? isDefeated,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return BossesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      chapter: chapter ?? this.chapter,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      iconAsset: iconAsset ?? this.iconAsset,
      isDefeated: isDefeated ?? this.isDefeated,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (maxHp.present) {
      map['max_hp'] = Variable<int>(maxHp.value);
    }
    if (currentHp.present) {
      map['current_hp'] = Variable<int>(currentHp.value);
    }
    if (iconAsset.present) {
      map['icon_asset'] = Variable<String>(iconAsset.value);
    }
    if (isDefeated.present) {
      map['is_defeated'] = Variable<bool>(isDefeated.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BossesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('chapter: $chapter, ')
          ..write('maxHp: $maxHp, ')
          ..write('currentHp: $currentHp, ')
          ..write('iconAsset: $iconAsset, ')
          ..write('isDefeated: $isDefeated, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestsTable extends Quests with TableInfo<$QuestsTable, Quest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<String> rank = GeneratedColumn<String>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('E'),
  );
  static const VerificationMeta _baseDamageMeta = const VerificationMeta(
    'baseDamage',
  );
  @override
  late final GeneratedColumn<int> baseDamage = GeneratedColumn<int>(
    'base_damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(25),
  );
  static const VerificationMeta _expRewardMeta = const VerificationMeta(
    'expReward',
  );
  @override
  late final GeneratedColumn<int> expReward = GeneratedColumn<int>(
    'exp_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _coinRewardMeta = const VerificationMeta(
    'coinReward',
  );
  @override
  late final GeneratedColumn<int> coinReward = GeneratedColumn<int>(
    'coin_reward',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    rank,
    baseDamage,
    expReward,
    coinReward,
    isCompleted,
    createdAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    if (data.containsKey('base_damage')) {
      context.handle(
        _baseDamageMeta,
        baseDamage.isAcceptableOrUnknown(data['base_damage']!, _baseDamageMeta),
      );
    }
    if (data.containsKey('exp_reward')) {
      context.handle(
        _expRewardMeta,
        expReward.isAcceptableOrUnknown(data['exp_reward']!, _expRewardMeta),
      );
    }
    if (data.containsKey('coin_reward')) {
      context.handle(
        _coinRewardMeta,
        coinReward.isAcceptableOrUnknown(data['coin_reward']!, _coinRewardMeta),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rank'],
      )!,
      baseDamage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_damage'],
      )!,
      expReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp_reward'],
      )!,
      coinReward: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coin_reward'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $QuestsTable createAlias(String alias) {
    return $QuestsTable(attachedDatabase, alias);
  }
}

class Quest extends DataClass implements Insertable<Quest> {
  final String id;
  final String title;
  final String description;
  final String rank;
  final int baseDamage;
  final int expReward;
  final int coinReward;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.rank,
    required this.baseDamage,
    required this.expReward,
    required this.coinReward,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['rank'] = Variable<String>(rank);
    map['base_damage'] = Variable<int>(baseDamage);
    map['exp_reward'] = Variable<int>(expReward);
    map['coin_reward'] = Variable<int>(coinReward);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  QuestsCompanion toCompanion(bool nullToAbsent) {
    return QuestsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      rank: Value(rank),
      baseDamage: Value(baseDamage),
      expReward: Value(expReward),
      coinReward: Value(coinReward),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory Quest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quest(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      rank: serializer.fromJson<String>(json['rank']),
      baseDamage: serializer.fromJson<int>(json['baseDamage']),
      expReward: serializer.fromJson<int>(json['expReward']),
      coinReward: serializer.fromJson<int>(json['coinReward']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'rank': serializer.toJson<String>(rank),
      'baseDamage': serializer.toJson<int>(baseDamage),
      'expReward': serializer.toJson<int>(expReward),
      'coinReward': serializer.toJson<int>(coinReward),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  Quest copyWith({
    String? id,
    String? title,
    String? description,
    String? rank,
    int? baseDamage,
    int? expReward,
    int? coinReward,
    bool? isCompleted,
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => Quest(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    rank: rank ?? this.rank,
    baseDamage: baseDamage ?? this.baseDamage,
    expReward: expReward ?? this.expReward,
    coinReward: coinReward ?? this.coinReward,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  Quest copyWithCompanion(QuestsCompanion data) {
    return Quest(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      rank: data.rank.present ? data.rank.value : this.rank,
      baseDamage: data.baseDamage.present
          ? data.baseDamage.value
          : this.baseDamage,
      expReward: data.expReward.present ? data.expReward.value : this.expReward,
      coinReward: data.coinReward.present
          ? data.coinReward.value
          : this.coinReward,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quest(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rank: $rank, ')
          ..write('baseDamage: $baseDamage, ')
          ..write('expReward: $expReward, ')
          ..write('coinReward: $coinReward, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    rank,
    baseDamage,
    expReward,
    coinReward,
    isCompleted,
    createdAt,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quest &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.rank == this.rank &&
          other.baseDamage == this.baseDamage &&
          other.expReward == this.expReward &&
          other.coinReward == this.coinReward &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class QuestsCompanion extends UpdateCompanion<Quest> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> rank;
  final Value<int> baseDamage;
  final Value<int> expReward;
  final Value<int> coinReward;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const QuestsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.rank = const Value.absent(),
    this.baseDamage = const Value.absent(),
    this.expReward = const Value.absent(),
    this.coinReward = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.rank = const Value.absent(),
    this.baseDamage = const Value.absent(),
    this.expReward = const Value.absent(),
    this.coinReward = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<Quest> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? rank,
    Expression<int>? baseDamage,
    Expression<int>? expReward,
    Expression<int>? coinReward,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (rank != null) 'rank': rank,
      if (baseDamage != null) 'base_damage': baseDamage,
      if (expReward != null) 'exp_reward': expReward,
      if (coinReward != null) 'coin_reward': coinReward,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? rank,
    Value<int>? baseDamage,
    Value<int>? expReward,
    Value<int>? coinReward,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return QuestsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rank: rank ?? this.rank,
      baseDamage: baseDamage ?? this.baseDamage,
      expReward: expReward ?? this.expReward,
      coinReward: coinReward ?? this.coinReward,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rank.present) {
      map['rank'] = Variable<String>(rank.value);
    }
    if (baseDamage.present) {
      map['base_damage'] = Variable<int>(baseDamage.value);
    }
    if (expReward.present) {
      map['exp_reward'] = Variable<int>(expReward.value);
    }
    if (coinReward.present) {
      map['coin_reward'] = Variable<int>(coinReward.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('rank: $rank, ')
          ..write('baseDamage: $baseDamage, ')
          ..write('expReward: $expReward, ')
          ..write('coinReward: $coinReward, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyQuestsTable extends DailyQuests
    with TableInfo<$DailyQuestsTable, DailyQuest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyQuestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCompletedDateMeta = const VerificationMeta(
    'lastCompletedDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastCompletedDate =
      GeneratedColumn<DateTime>(
        'last_completed_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    isCompleted,
    streak,
    lastCompletedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_quests';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyQuest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    }
    if (data.containsKey('last_completed_date')) {
      context.handle(
        _lastCompletedDateMeta,
        lastCompletedDate.isAcceptableOrUnknown(
          data['last_completed_date']!,
          _lastCompletedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyQuest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyQuest(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
      lastCompletedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_completed_date'],
      ),
    );
  }

  @override
  $DailyQuestsTable createAlias(String alias) {
    return $DailyQuestsTable(attachedDatabase, alias);
  }
}

class DailyQuest extends DataClass implements Insertable<DailyQuest> {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final int streak;
  final DateTime? lastCompletedDate;
  const DailyQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.streak,
    this.lastCompletedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['streak'] = Variable<int>(streak);
    if (!nullToAbsent || lastCompletedDate != null) {
      map['last_completed_date'] = Variable<DateTime>(lastCompletedDate);
    }
    return map;
  }

  DailyQuestsCompanion toCompanion(bool nullToAbsent) {
    return DailyQuestsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      isCompleted: Value(isCompleted),
      streak: Value(streak),
      lastCompletedDate: lastCompletedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedDate),
    );
  }

  factory DailyQuest.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyQuest(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      streak: serializer.fromJson<int>(json['streak']),
      lastCompletedDate: serializer.fromJson<DateTime?>(
        json['lastCompletedDate'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'streak': serializer.toJson<int>(streak),
      'lastCompletedDate': serializer.toJson<DateTime?>(lastCompletedDate),
    };
  }

  DailyQuest copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? streak,
    Value<DateTime?> lastCompletedDate = const Value.absent(),
  }) => DailyQuest(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    isCompleted: isCompleted ?? this.isCompleted,
    streak: streak ?? this.streak,
    lastCompletedDate: lastCompletedDate.present
        ? lastCompletedDate.value
        : this.lastCompletedDate,
  );
  DailyQuest copyWithCompanion(DailyQuestsCompanion data) {
    return DailyQuest(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      streak: data.streak.present ? data.streak.value : this.streak,
      lastCompletedDate: data.lastCompletedDate.present
          ? data.lastCompletedDate.value
          : this.lastCompletedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuest(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('streak: $streak, ')
          ..write('lastCompletedDate: $lastCompletedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    isCompleted,
    streak,
    lastCompletedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyQuest &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.isCompleted == this.isCompleted &&
          other.streak == this.streak &&
          other.lastCompletedDate == this.lastCompletedDate);
}

class DailyQuestsCompanion extends UpdateCompanion<DailyQuest> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<bool> isCompleted;
  final Value<int> streak;
  final Value<DateTime?> lastCompletedDate;
  final Value<int> rowid;
  const DailyQuestsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.streak = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyQuestsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.streak = const Value.absent(),
    this.lastCompletedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<DailyQuest> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<bool>? isCompleted,
    Expression<int>? streak,
    Expression<DateTime>? lastCompletedDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (streak != null) 'streak': streak,
      if (lastCompletedDate != null) 'last_completed_date': lastCompletedDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyQuestsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<bool>? isCompleted,
    Value<int>? streak,
    Value<DateTime?>? lastCompletedDate,
    Value<int>? rowid,
  }) {
    return DailyQuestsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      streak: streak ?? this.streak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (lastCompletedDate.present) {
      map['last_completed_date'] = Variable<DateTime>(lastCompletedDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyQuestsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('streak: $streak, ')
          ..write('lastCompletedDate: $lastCompletedDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPositiveMeta = const VerificationMeta(
    'isPositive',
  );
  @override
  late final GeneratedColumn<bool> isPositive = GeneratedColumn<bool>(
    'is_positive',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_positive" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isNegativeMeta = const VerificationMeta(
    'isNegative',
  );
  @override
  late final GeneratedColumn<bool> isNegative = GeneratedColumn<bool>(
    'is_negative',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_negative" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _positiveCountMeta = const VerificationMeta(
    'positiveCount',
  );
  @override
  late final GeneratedColumn<int> positiveCount = GeneratedColumn<int>(
    'positive_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _negativeCountMeta = const VerificationMeta(
    'negativeCount',
  );
  @override
  late final GeneratedColumn<int> negativeCount = GeneratedColumn<int>(
    'negative_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _historyDatesJsonMeta = const VerificationMeta(
    'historyDatesJson',
  );
  @override
  late final GeneratedColumn<String> historyDatesJson = GeneratedColumn<String>(
    'history_dates_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    isPositive,
    isNegative,
    positiveCount,
    negativeCount,
    historyDatesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_positive')) {
      context.handle(
        _isPositiveMeta,
        isPositive.isAcceptableOrUnknown(data['is_positive']!, _isPositiveMeta),
      );
    }
    if (data.containsKey('is_negative')) {
      context.handle(
        _isNegativeMeta,
        isNegative.isAcceptableOrUnknown(data['is_negative']!, _isNegativeMeta),
      );
    }
    if (data.containsKey('positive_count')) {
      context.handle(
        _positiveCountMeta,
        positiveCount.isAcceptableOrUnknown(
          data['positive_count']!,
          _positiveCountMeta,
        ),
      );
    }
    if (data.containsKey('negative_count')) {
      context.handle(
        _negativeCountMeta,
        negativeCount.isAcceptableOrUnknown(
          data['negative_count']!,
          _negativeCountMeta,
        ),
      );
    }
    if (data.containsKey('history_dates_json')) {
      context.handle(
        _historyDatesJsonMeta,
        historyDatesJson.isAcceptableOrUnknown(
          data['history_dates_json']!,
          _historyDatesJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isPositive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_positive'],
      )!,
      isNegative: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_negative'],
      )!,
      positiveCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}positive_count'],
      )!,
      negativeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}negative_count'],
      )!,
      historyDatesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}history_dates_json'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final String title;
  final bool isPositive;
  final bool isNegative;
  final int positiveCount;
  final int negativeCount;
  final String historyDatesJson;
  const Habit({
    required this.id,
    required this.title,
    required this.isPositive,
    required this.isNegative,
    required this.positiveCount,
    required this.negativeCount,
    required this.historyDatesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['is_positive'] = Variable<bool>(isPositive);
    map['is_negative'] = Variable<bool>(isNegative);
    map['positive_count'] = Variable<int>(positiveCount);
    map['negative_count'] = Variable<int>(negativeCount);
    map['history_dates_json'] = Variable<String>(historyDatesJson);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      title: Value(title),
      isPositive: Value(isPositive),
      isNegative: Value(isNegative),
      positiveCount: Value(positiveCount),
      negativeCount: Value(negativeCount),
      historyDatesJson: Value(historyDatesJson),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      isPositive: serializer.fromJson<bool>(json['isPositive']),
      isNegative: serializer.fromJson<bool>(json['isNegative']),
      positiveCount: serializer.fromJson<int>(json['positiveCount']),
      negativeCount: serializer.fromJson<int>(json['negativeCount']),
      historyDatesJson: serializer.fromJson<String>(json['historyDatesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'isPositive': serializer.toJson<bool>(isPositive),
      'isNegative': serializer.toJson<bool>(isNegative),
      'positiveCount': serializer.toJson<int>(positiveCount),
      'negativeCount': serializer.toJson<int>(negativeCount),
      'historyDatesJson': serializer.toJson<String>(historyDatesJson),
    };
  }

  Habit copyWith({
    String? id,
    String? title,
    bool? isPositive,
    bool? isNegative,
    int? positiveCount,
    int? negativeCount,
    String? historyDatesJson,
  }) => Habit(
    id: id ?? this.id,
    title: title ?? this.title,
    isPositive: isPositive ?? this.isPositive,
    isNegative: isNegative ?? this.isNegative,
    positiveCount: positiveCount ?? this.positiveCount,
    negativeCount: negativeCount ?? this.negativeCount,
    historyDatesJson: historyDatesJson ?? this.historyDatesJson,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isPositive: data.isPositive.present
          ? data.isPositive.value
          : this.isPositive,
      isNegative: data.isNegative.present
          ? data.isNegative.value
          : this.isNegative,
      positiveCount: data.positiveCount.present
          ? data.positiveCount.value
          : this.positiveCount,
      negativeCount: data.negativeCount.present
          ? data.negativeCount.value
          : this.negativeCount,
      historyDatesJson: data.historyDatesJson.present
          ? data.historyDatesJson.value
          : this.historyDatesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isPositive: $isPositive, ')
          ..write('isNegative: $isNegative, ')
          ..write('positiveCount: $positiveCount, ')
          ..write('negativeCount: $negativeCount, ')
          ..write('historyDatesJson: $historyDatesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    isPositive,
    isNegative,
    positiveCount,
    negativeCount,
    historyDatesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.title == this.title &&
          other.isPositive == this.isPositive &&
          other.isNegative == this.isNegative &&
          other.positiveCount == this.positiveCount &&
          other.negativeCount == this.negativeCount &&
          other.historyDatesJson == this.historyDatesJson);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<String> title;
  final Value<bool> isPositive;
  final Value<bool> isNegative;
  final Value<int> positiveCount;
  final Value<int> negativeCount;
  final Value<String> historyDatesJson;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isPositive = const Value.absent(),
    this.isNegative = const Value.absent(),
    this.positiveCount = const Value.absent(),
    this.negativeCount = const Value.absent(),
    this.historyDatesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String title,
    this.isPositive = const Value.absent(),
    this.isNegative = const Value.absent(),
    this.positiveCount = const Value.absent(),
    this.negativeCount = const Value.absent(),
    this.historyDatesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<bool>? isPositive,
    Expression<bool>? isNegative,
    Expression<int>? positiveCount,
    Expression<int>? negativeCount,
    Expression<String>? historyDatesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isPositive != null) 'is_positive': isPositive,
      if (isNegative != null) 'is_negative': isNegative,
      if (positiveCount != null) 'positive_count': positiveCount,
      if (negativeCount != null) 'negative_count': negativeCount,
      if (historyDatesJson != null) 'history_dates_json': historyDatesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<bool>? isPositive,
    Value<bool>? isNegative,
    Value<int>? positiveCount,
    Value<int>? negativeCount,
    Value<String>? historyDatesJson,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isPositive: isPositive ?? this.isPositive,
      isNegative: isNegative ?? this.isNegative,
      positiveCount: positiveCount ?? this.positiveCount,
      negativeCount: negativeCount ?? this.negativeCount,
      historyDatesJson: historyDatesJson ?? this.historyDatesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isPositive.present) {
      map['is_positive'] = Variable<bool>(isPositive.value);
    }
    if (isNegative.present) {
      map['is_negative'] = Variable<bool>(isNegative.value);
    }
    if (positiveCount.present) {
      map['positive_count'] = Variable<int>(positiveCount.value);
    }
    if (negativeCount.present) {
      map['negative_count'] = Variable<int>(negativeCount.value);
    }
    if (historyDatesJson.present) {
      map['history_dates_json'] = Variable<String>(historyDatesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isPositive: $isPositive, ')
          ..write('isNegative: $isNegative, ')
          ..write('positiveCount: $positiveCount, ')
          ..write('negativeCount: $negativeCount, ')
          ..write('historyDatesJson: $historyDatesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TavernItemsTable extends TavernItems
    with TableInfo<$TavernItemsTable, TavernItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TavernItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effectTypeMeta = const VerificationMeta(
    'effectType',
  );
  @override
  late final GeneratedColumn<String> effectType = GeneratedColumn<String>(
    'effect_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _effectValueMeta = const VerificationMeta(
    'effectValue',
  );
  @override
  late final GeneratedColumn<int> effectValue = GeneratedColumn<int>(
    'effect_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _iconAssetMeta = const VerificationMeta(
    'iconAsset',
  );
  @override
  late final GeneratedColumn<String> iconAsset = GeneratedColumn<String>(
    'icon_asset',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPurchasedMeta = const VerificationMeta(
    'isPurchased',
  );
  @override
  late final GeneratedColumn<bool> isPurchased = GeneratedColumn<bool>(
    'is_purchased',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_purchased" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    category,
    cost,
    effectType,
    effectValue,
    iconAsset,
    isPurchased,
    quantity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tavern_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TavernItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('effect_type')) {
      context.handle(
        _effectTypeMeta,
        effectType.isAcceptableOrUnknown(data['effect_type']!, _effectTypeMeta),
      );
    }
    if (data.containsKey('effect_value')) {
      context.handle(
        _effectValueMeta,
        effectValue.isAcceptableOrUnknown(
          data['effect_value']!,
          _effectValueMeta,
        ),
      );
    }
    if (data.containsKey('icon_asset')) {
      context.handle(
        _iconAssetMeta,
        iconAsset.isAcceptableOrUnknown(data['icon_asset']!, _iconAssetMeta),
      );
    } else if (isInserting) {
      context.missing(_iconAssetMeta);
    }
    if (data.containsKey('is_purchased')) {
      context.handle(
        _isPurchasedMeta,
        isPurchased.isAcceptableOrUnknown(
          data['is_purchased']!,
          _isPurchasedMeta,
        ),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TavernItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TavernItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      effectType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effect_type'],
      )!,
      effectValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effect_value'],
      )!,
      iconAsset: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_asset'],
      )!,
      isPurchased: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_purchased'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
    );
  }

  @override
  $TavernItemsTable createAlias(String alias) {
    return $TavernItemsTable(attachedDatabase, alias);
  }
}

class TavernItem extends DataClass implements Insertable<TavernItem> {
  final String id;
  final String name;
  final String description;
  final String category;
  final int cost;
  final String effectType;
  final int effectValue;
  final String iconAsset;
  final bool isPurchased;
  final int quantity;
  const TavernItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.cost,
    required this.effectType,
    required this.effectValue,
    required this.iconAsset,
    required this.isPurchased,
    required this.quantity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['cost'] = Variable<int>(cost);
    map['effect_type'] = Variable<String>(effectType);
    map['effect_value'] = Variable<int>(effectValue);
    map['icon_asset'] = Variable<String>(iconAsset);
    map['is_purchased'] = Variable<bool>(isPurchased);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  TavernItemsCompanion toCompanion(bool nullToAbsent) {
    return TavernItemsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      category: Value(category),
      cost: Value(cost),
      effectType: Value(effectType),
      effectValue: Value(effectValue),
      iconAsset: Value(iconAsset),
      isPurchased: Value(isPurchased),
      quantity: Value(quantity),
    );
  }

  factory TavernItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TavernItem(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      cost: serializer.fromJson<int>(json['cost']),
      effectType: serializer.fromJson<String>(json['effectType']),
      effectValue: serializer.fromJson<int>(json['effectValue']),
      iconAsset: serializer.fromJson<String>(json['iconAsset']),
      isPurchased: serializer.fromJson<bool>(json['isPurchased']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'cost': serializer.toJson<int>(cost),
      'effectType': serializer.toJson<String>(effectType),
      'effectValue': serializer.toJson<int>(effectValue),
      'iconAsset': serializer.toJson<String>(iconAsset),
      'isPurchased': serializer.toJson<bool>(isPurchased),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  TavernItem copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    int? cost,
    String? effectType,
    int? effectValue,
    String? iconAsset,
    bool? isPurchased,
    int? quantity,
  }) => TavernItem(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    category: category ?? this.category,
    cost: cost ?? this.cost,
    effectType: effectType ?? this.effectType,
    effectValue: effectValue ?? this.effectValue,
    iconAsset: iconAsset ?? this.iconAsset,
    isPurchased: isPurchased ?? this.isPurchased,
    quantity: quantity ?? this.quantity,
  );
  TavernItem copyWithCompanion(TavernItemsCompanion data) {
    return TavernItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      cost: data.cost.present ? data.cost.value : this.cost,
      effectType: data.effectType.present
          ? data.effectType.value
          : this.effectType,
      effectValue: data.effectValue.present
          ? data.effectValue.value
          : this.effectValue,
      iconAsset: data.iconAsset.present ? data.iconAsset.value : this.iconAsset,
      isPurchased: data.isPurchased.present
          ? data.isPurchased.value
          : this.isPurchased,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TavernItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('cost: $cost, ')
          ..write('effectType: $effectType, ')
          ..write('effectValue: $effectValue, ')
          ..write('iconAsset: $iconAsset, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    category,
    cost,
    effectType,
    effectValue,
    iconAsset,
    isPurchased,
    quantity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TavernItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.cost == this.cost &&
          other.effectType == this.effectType &&
          other.effectValue == this.effectValue &&
          other.iconAsset == this.iconAsset &&
          other.isPurchased == this.isPurchased &&
          other.quantity == this.quantity);
}

class TavernItemsCompanion extends UpdateCompanion<TavernItem> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> category;
  final Value<int> cost;
  final Value<String> effectType;
  final Value<int> effectValue;
  final Value<String> iconAsset;
  final Value<bool> isPurchased;
  final Value<int> quantity;
  final Value<int> rowid;
  const TavernItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.cost = const Value.absent(),
    this.effectType = const Value.absent(),
    this.effectValue = const Value.absent(),
    this.iconAsset = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TavernItemsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String category,
    required int cost,
    this.effectType = const Value.absent(),
    this.effectValue = const Value.absent(),
    required String iconAsset,
    this.isPurchased = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       cost = Value(cost),
       iconAsset = Value(iconAsset);
  static Insertable<TavernItem> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<int>? cost,
    Expression<String>? effectType,
    Expression<int>? effectValue,
    Expression<String>? iconAsset,
    Expression<bool>? isPurchased,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (cost != null) 'cost': cost,
      if (effectType != null) 'effect_type': effectType,
      if (effectValue != null) 'effect_value': effectValue,
      if (iconAsset != null) 'icon_asset': iconAsset,
      if (isPurchased != null) 'is_purchased': isPurchased,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TavernItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? category,
    Value<int>? cost,
    Value<String>? effectType,
    Value<int>? effectValue,
    Value<String>? iconAsset,
    Value<bool>? isPurchased,
    Value<int>? quantity,
    Value<int>? rowid,
  }) {
    return TavernItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      cost: cost ?? this.cost,
      effectType: effectType ?? this.effectType,
      effectValue: effectValue ?? this.effectValue,
      iconAsset: iconAsset ?? this.iconAsset,
      isPurchased: isPurchased ?? this.isPurchased,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (effectType.present) {
      map['effect_type'] = Variable<String>(effectType.value);
    }
    if (effectValue.present) {
      map['effect_value'] = Variable<int>(effectValue.value);
    }
    if (iconAsset.present) {
      map['icon_asset'] = Variable<String>(iconAsset.value);
    }
    if (isPurchased.present) {
      map['is_purchased'] = Variable<bool>(isPurchased.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TavernItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('cost: $cost, ')
          ..write('effectType: $effectType, ')
          ..write('effectValue: $effectValue, ')
          ..write('iconAsset: $iconAsset, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CombatLogsTable extends CombatLogs
    with TableInfo<$CombatLogsTable, CombatLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CombatLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _textContentMeta = const VerificationMeta(
    'textContent',
  );
  @override
  late final GeneratedColumn<String> textContent = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _damageMeta = const VerificationMeta('damage');
  @override
  late final GeneratedColumn<int> damage = GeneratedColumn<int>(
    'damage',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCriticalMeta = const VerificationMeta(
    'isCritical',
  );
  @override
  late final GeneratedColumn<bool> isCritical = GeneratedColumn<bool>(
    'is_critical',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_critical" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    textContent,
    damage,
    isCritical,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'combat_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CombatLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('text')) {
      context.handle(
        _textContentMeta,
        textContent.isAcceptableOrUnknown(data['text']!, _textContentMeta),
      );
    } else if (isInserting) {
      context.missing(_textContentMeta);
    }
    if (data.containsKey('damage')) {
      context.handle(
        _damageMeta,
        damage.isAcceptableOrUnknown(data['damage']!, _damageMeta),
      );
    }
    if (data.containsKey('is_critical')) {
      context.handle(
        _isCriticalMeta,
        isCritical.isAcceptableOrUnknown(data['is_critical']!, _isCriticalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CombatLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CombatLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      textContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      damage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}damage'],
      )!,
      isCritical: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_critical'],
      )!,
    );
  }

  @override
  $CombatLogsTable createAlias(String alias) {
    return $CombatLogsTable(attachedDatabase, alias);
  }
}

class CombatLog extends DataClass implements Insertable<CombatLog> {
  final String id;
  final DateTime timestamp;
  final String textContent;
  final int damage;
  final bool isCritical;
  const CombatLog({
    required this.id,
    required this.timestamp,
    required this.textContent,
    required this.damage,
    required this.isCritical,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['text'] = Variable<String>(textContent);
    map['damage'] = Variable<int>(damage);
    map['is_critical'] = Variable<bool>(isCritical);
    return map;
  }

  CombatLogsCompanion toCompanion(bool nullToAbsent) {
    return CombatLogsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      textContent: Value(textContent),
      damage: Value(damage),
      isCritical: Value(isCritical),
    );
  }

  factory CombatLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CombatLog(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      textContent: serializer.fromJson<String>(json['textContent']),
      damage: serializer.fromJson<int>(json['damage']),
      isCritical: serializer.fromJson<bool>(json['isCritical']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'textContent': serializer.toJson<String>(textContent),
      'damage': serializer.toJson<int>(damage),
      'isCritical': serializer.toJson<bool>(isCritical),
    };
  }

  CombatLog copyWith({
    String? id,
    DateTime? timestamp,
    String? textContent,
    int? damage,
    bool? isCritical,
  }) => CombatLog(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    textContent: textContent ?? this.textContent,
    damage: damage ?? this.damage,
    isCritical: isCritical ?? this.isCritical,
  );
  CombatLog copyWithCompanion(CombatLogsCompanion data) {
    return CombatLog(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      textContent: data.textContent.present
          ? data.textContent.value
          : this.textContent,
      damage: data.damage.present ? data.damage.value : this.damage,
      isCritical: data.isCritical.present
          ? data.isCritical.value
          : this.isCritical,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CombatLog(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('textContent: $textContent, ')
          ..write('damage: $damage, ')
          ..write('isCritical: $isCritical')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, timestamp, textContent, damage, isCritical);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CombatLog &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.textContent == this.textContent &&
          other.damage == this.damage &&
          other.isCritical == this.isCritical);
}

class CombatLogsCompanion extends UpdateCompanion<CombatLog> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<String> textContent;
  final Value<int> damage;
  final Value<bool> isCritical;
  final Value<int> rowid;
  const CombatLogsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.textContent = const Value.absent(),
    this.damage = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CombatLogsCompanion.insert({
    required String id,
    this.timestamp = const Value.absent(),
    required String textContent,
    this.damage = const Value.absent(),
    this.isCritical = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       textContent = Value(textContent);
  static Insertable<CombatLog> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? textContent,
    Expression<int>? damage,
    Expression<bool>? isCritical,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (textContent != null) 'text': textContent,
      if (damage != null) 'damage': damage,
      if (isCritical != null) 'is_critical': isCritical,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CombatLogsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? timestamp,
    Value<String>? textContent,
    Value<int>? damage,
    Value<bool>? isCritical,
    Value<int>? rowid,
  }) {
    return CombatLogsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      textContent: textContent ?? this.textContent,
      damage: damage ?? this.damage,
      isCritical: isCritical ?? this.isCritical,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (textContent.present) {
      map['text'] = Variable<String>(textContent.value);
    }
    if (damage.present) {
      map['damage'] = Variable<int>(damage.value);
    }
    if (isCritical.present) {
      map['is_critical'] = Variable<bool>(isCritical.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CombatLogsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('textContent: $textContent, ')
          ..write('damage: $damage, ')
          ..write('isCritical: $isCritical, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HeroesTable heroes = $HeroesTable(this);
  late final $BossesTable bosses = $BossesTable(this);
  late final $QuestsTable quests = $QuestsTable(this);
  late final $DailyQuestsTable dailyQuests = $DailyQuestsTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $TavernItemsTable tavernItems = $TavernItemsTable(this);
  late final $CombatLogsTable combatLogs = $CombatLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    heroes,
    bosses,
    quests,
    dailyQuests,
    habits,
    tavernItems,
    combatLogs,
  ];
}

typedef $$HeroesTableCreateCompanionBuilder =
    HeroesCompanion Function({
      required String id,
      Value<String> name,
      Value<int> level,
      Value<int> currentExp,
      Value<int> hp,
      Value<int> maxHp,
      Value<int> mp,
      Value<int> maxMp,
      Value<int> coins,
      Value<int> str,
      Value<int> agi,
      Value<int> intAttr,
      Value<int> vit,
      Value<int> unspentStatPoints,
      Value<bool> isGhost,
      Value<String> activeTitle,
      Value<String> avatarSkinId,
      Value<String> bannerId,
      Value<int> rowid,
    });
typedef $$HeroesTableUpdateCompanionBuilder =
    HeroesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> level,
      Value<int> currentExp,
      Value<int> hp,
      Value<int> maxHp,
      Value<int> mp,
      Value<int> maxMp,
      Value<int> coins,
      Value<int> str,
      Value<int> agi,
      Value<int> intAttr,
      Value<int> vit,
      Value<int> unspentStatPoints,
      Value<bool> isGhost,
      Value<String> activeTitle,
      Value<String> avatarSkinId,
      Value<String> bannerId,
      Value<int> rowid,
    });

class $$HeroesTableFilterComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentExp => $composableBuilder(
    column: $table.currentExp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hp => $composableBuilder(
    column: $table.hp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHp => $composableBuilder(
    column: $table.maxHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mp => $composableBuilder(
    column: $table.mp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxMp => $composableBuilder(
    column: $table.maxMp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get str => $composableBuilder(
    column: $table.str,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get agi => $composableBuilder(
    column: $table.agi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intAttr => $composableBuilder(
    column: $table.intAttr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vit => $composableBuilder(
    column: $table.vit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unspentStatPoints => $composableBuilder(
    column: $table.unspentStatPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGhost => $composableBuilder(
    column: $table.isGhost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeTitle => $composableBuilder(
    column: $table.activeTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarSkinId => $composableBuilder(
    column: $table.avatarSkinId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bannerId => $composableBuilder(
    column: $table.bannerId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HeroesTableOrderingComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentExp => $composableBuilder(
    column: $table.currentExp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hp => $composableBuilder(
    column: $table.hp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHp => $composableBuilder(
    column: $table.maxHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mp => $composableBuilder(
    column: $table.mp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxMp => $composableBuilder(
    column: $table.maxMp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coins => $composableBuilder(
    column: $table.coins,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get str => $composableBuilder(
    column: $table.str,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get agi => $composableBuilder(
    column: $table.agi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intAttr => $composableBuilder(
    column: $table.intAttr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vit => $composableBuilder(
    column: $table.vit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unspentStatPoints => $composableBuilder(
    column: $table.unspentStatPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGhost => $composableBuilder(
    column: $table.isGhost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeTitle => $composableBuilder(
    column: $table.activeTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarSkinId => $composableBuilder(
    column: $table.avatarSkinId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bannerId => $composableBuilder(
    column: $table.bannerId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HeroesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get currentExp => $composableBuilder(
    column: $table.currentExp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hp =>
      $composableBuilder(column: $table.hp, builder: (column) => column);

  GeneratedColumn<int> get maxHp =>
      $composableBuilder(column: $table.maxHp, builder: (column) => column);

  GeneratedColumn<int> get mp =>
      $composableBuilder(column: $table.mp, builder: (column) => column);

  GeneratedColumn<int> get maxMp =>
      $composableBuilder(column: $table.maxMp, builder: (column) => column);

  GeneratedColumn<int> get coins =>
      $composableBuilder(column: $table.coins, builder: (column) => column);

  GeneratedColumn<int> get str =>
      $composableBuilder(column: $table.str, builder: (column) => column);

  GeneratedColumn<int> get agi =>
      $composableBuilder(column: $table.agi, builder: (column) => column);

  GeneratedColumn<int> get intAttr =>
      $composableBuilder(column: $table.intAttr, builder: (column) => column);

  GeneratedColumn<int> get vit =>
      $composableBuilder(column: $table.vit, builder: (column) => column);

  GeneratedColumn<int> get unspentStatPoints => $composableBuilder(
    column: $table.unspentStatPoints,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isGhost =>
      $composableBuilder(column: $table.isGhost, builder: (column) => column);

  GeneratedColumn<String> get activeTitle => $composableBuilder(
    column: $table.activeTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarSkinId => $composableBuilder(
    column: $table.avatarSkinId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bannerId =>
      $composableBuilder(column: $table.bannerId, builder: (column) => column);
}

class $$HeroesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HeroesTable,
          Hero,
          $$HeroesTableFilterComposer,
          $$HeroesTableOrderingComposer,
          $$HeroesTableAnnotationComposer,
          $$HeroesTableCreateCompanionBuilder,
          $$HeroesTableUpdateCompanionBuilder,
          (Hero, BaseReferences<_$AppDatabase, $HeroesTable, Hero>),
          Hero,
          PrefetchHooks Function()
        > {
  $$HeroesTableTableManager(_$AppDatabase db, $HeroesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeroesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeroesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeroesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> currentExp = const Value.absent(),
                Value<int> hp = const Value.absent(),
                Value<int> maxHp = const Value.absent(),
                Value<int> mp = const Value.absent(),
                Value<int> maxMp = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<int> str = const Value.absent(),
                Value<int> agi = const Value.absent(),
                Value<int> intAttr = const Value.absent(),
                Value<int> vit = const Value.absent(),
                Value<int> unspentStatPoints = const Value.absent(),
                Value<bool> isGhost = const Value.absent(),
                Value<String> activeTitle = const Value.absent(),
                Value<String> avatarSkinId = const Value.absent(),
                Value<String> bannerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HeroesCompanion(
                id: id,
                name: name,
                level: level,
                currentExp: currentExp,
                hp: hp,
                maxHp: maxHp,
                mp: mp,
                maxMp: maxMp,
                coins: coins,
                str: str,
                agi: agi,
                intAttr: intAttr,
                vit: vit,
                unspentStatPoints: unspentStatPoints,
                isGhost: isGhost,
                activeTitle: activeTitle,
                avatarSkinId: avatarSkinId,
                bannerId: bannerId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> name = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> currentExp = const Value.absent(),
                Value<int> hp = const Value.absent(),
                Value<int> maxHp = const Value.absent(),
                Value<int> mp = const Value.absent(),
                Value<int> maxMp = const Value.absent(),
                Value<int> coins = const Value.absent(),
                Value<int> str = const Value.absent(),
                Value<int> agi = const Value.absent(),
                Value<int> intAttr = const Value.absent(),
                Value<int> vit = const Value.absent(),
                Value<int> unspentStatPoints = const Value.absent(),
                Value<bool> isGhost = const Value.absent(),
                Value<String> activeTitle = const Value.absent(),
                Value<String> avatarSkinId = const Value.absent(),
                Value<String> bannerId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HeroesCompanion.insert(
                id: id,
                name: name,
                level: level,
                currentExp: currentExp,
                hp: hp,
                maxHp: maxHp,
                mp: mp,
                maxMp: maxMp,
                coins: coins,
                str: str,
                agi: agi,
                intAttr: intAttr,
                vit: vit,
                unspentStatPoints: unspentStatPoints,
                isGhost: isGhost,
                activeTitle: activeTitle,
                avatarSkinId: avatarSkinId,
                bannerId: bannerId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HeroesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HeroesTable,
      Hero,
      $$HeroesTableFilterComposer,
      $$HeroesTableOrderingComposer,
      $$HeroesTableAnnotationComposer,
      $$HeroesTableCreateCompanionBuilder,
      $$HeroesTableUpdateCompanionBuilder,
      (Hero, BaseReferences<_$AppDatabase, $HeroesTable, Hero>),
      Hero,
      PrefetchHooks Function()
    >;
typedef $$BossesTableCreateCompanionBuilder =
    BossesCompanion Function({
      required String id,
      required String name,
      required int chapter,
      required int maxHp,
      required int currentHp,
      required String iconAsset,
      Value<bool> isDefeated,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$BossesTableUpdateCompanionBuilder =
    BossesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> chapter,
      Value<int> maxHp,
      Value<int> currentHp,
      Value<String> iconAsset,
      Value<bool> isDefeated,
      Value<bool> isActive,
      Value<int> rowid,
    });

class $$BossesTableFilterComposer
    extends Composer<_$AppDatabase, $BossesTable> {
  $$BossesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxHp => $composableBuilder(
    column: $table.maxHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentHp => $composableBuilder(
    column: $table.currentHp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconAsset => $composableBuilder(
    column: $table.iconAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefeated => $composableBuilder(
    column: $table.isDefeated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BossesTableOrderingComposer
    extends Composer<_$AppDatabase, $BossesTable> {
  $$BossesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapter => $composableBuilder(
    column: $table.chapter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxHp => $composableBuilder(
    column: $table.maxHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentHp => $composableBuilder(
    column: $table.currentHp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconAsset => $composableBuilder(
    column: $table.iconAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefeated => $composableBuilder(
    column: $table.isDefeated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BossesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BossesTable> {
  $$BossesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get maxHp =>
      $composableBuilder(column: $table.maxHp, builder: (column) => column);

  GeneratedColumn<int> get currentHp =>
      $composableBuilder(column: $table.currentHp, builder: (column) => column);

  GeneratedColumn<String> get iconAsset =>
      $composableBuilder(column: $table.iconAsset, builder: (column) => column);

  GeneratedColumn<bool> get isDefeated => $composableBuilder(
    column: $table.isDefeated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$BossesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BossesTable,
          Boss,
          $$BossesTableFilterComposer,
          $$BossesTableOrderingComposer,
          $$BossesTableAnnotationComposer,
          $$BossesTableCreateCompanionBuilder,
          $$BossesTableUpdateCompanionBuilder,
          (Boss, BaseReferences<_$AppDatabase, $BossesTable, Boss>),
          Boss,
          PrefetchHooks Function()
        > {
  $$BossesTableTableManager(_$AppDatabase db, $BossesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BossesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BossesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BossesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> chapter = const Value.absent(),
                Value<int> maxHp = const Value.absent(),
                Value<int> currentHp = const Value.absent(),
                Value<String> iconAsset = const Value.absent(),
                Value<bool> isDefeated = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BossesCompanion(
                id: id,
                name: name,
                chapter: chapter,
                maxHp: maxHp,
                currentHp: currentHp,
                iconAsset: iconAsset,
                isDefeated: isDefeated,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int chapter,
                required int maxHp,
                required int currentHp,
                required String iconAsset,
                Value<bool> isDefeated = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BossesCompanion.insert(
                id: id,
                name: name,
                chapter: chapter,
                maxHp: maxHp,
                currentHp: currentHp,
                iconAsset: iconAsset,
                isDefeated: isDefeated,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BossesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BossesTable,
      Boss,
      $$BossesTableFilterComposer,
      $$BossesTableOrderingComposer,
      $$BossesTableAnnotationComposer,
      $$BossesTableCreateCompanionBuilder,
      $$BossesTableUpdateCompanionBuilder,
      (Boss, BaseReferences<_$AppDatabase, $BossesTable, Boss>),
      Boss,
      PrefetchHooks Function()
    >;
typedef $$QuestsTableCreateCompanionBuilder =
    QuestsCompanion Function({
      required String id,
      required String title,
      Value<String> description,
      Value<String> rank,
      Value<int> baseDamage,
      Value<int> expReward,
      Value<int> coinReward,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$QuestsTableUpdateCompanionBuilder =
    QuestsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> rank,
      Value<int> baseDamage,
      Value<int> expReward,
      Value<int> coinReward,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

class $$QuestsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseDamage => $composableBuilder(
    column: $table.baseDamage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expReward => $composableBuilder(
    column: $table.expReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coinReward => $composableBuilder(
    column: $table.coinReward,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseDamage => $composableBuilder(
    column: $table.baseDamage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expReward => $composableBuilder(
    column: $table.expReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coinReward => $composableBuilder(
    column: $table.coinReward,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestsTable> {
  $$QuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<int> get baseDamage => $composableBuilder(
    column: $table.baseDamage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expReward =>
      $composableBuilder(column: $table.expReward, builder: (column) => column);

  GeneratedColumn<int> get coinReward => $composableBuilder(
    column: $table.coinReward,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$QuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestsTable,
          Quest,
          $$QuestsTableFilterComposer,
          $$QuestsTableOrderingComposer,
          $$QuestsTableAnnotationComposer,
          $$QuestsTableCreateCompanionBuilder,
          $$QuestsTableUpdateCompanionBuilder,
          (Quest, BaseReferences<_$AppDatabase, $QuestsTable, Quest>),
          Quest,
          PrefetchHooks Function()
        > {
  $$QuestsTableTableManager(_$AppDatabase db, $QuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> rank = const Value.absent(),
                Value<int> baseDamage = const Value.absent(),
                Value<int> expReward = const Value.absent(),
                Value<int> coinReward = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestsCompanion(
                id: id,
                title: title,
                description: description,
                rank: rank,
                baseDamage: baseDamage,
                expReward: expReward,
                coinReward: coinReward,
                isCompleted: isCompleted,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> description = const Value.absent(),
                Value<String> rank = const Value.absent(),
                Value<int> baseDamage = const Value.absent(),
                Value<int> expReward = const Value.absent(),
                Value<int> coinReward = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestsCompanion.insert(
                id: id,
                title: title,
                description: description,
                rank: rank,
                baseDamage: baseDamage,
                expReward: expReward,
                coinReward: coinReward,
                isCompleted: isCompleted,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestsTable,
      Quest,
      $$QuestsTableFilterComposer,
      $$QuestsTableOrderingComposer,
      $$QuestsTableAnnotationComposer,
      $$QuestsTableCreateCompanionBuilder,
      $$QuestsTableUpdateCompanionBuilder,
      (Quest, BaseReferences<_$AppDatabase, $QuestsTable, Quest>),
      Quest,
      PrefetchHooks Function()
    >;
typedef $$DailyQuestsTableCreateCompanionBuilder =
    DailyQuestsCompanion Function({
      required String id,
      required String title,
      Value<String> description,
      Value<bool> isCompleted,
      Value<int> streak,
      Value<DateTime?> lastCompletedDate,
      Value<int> rowid,
    });
typedef $$DailyQuestsTableUpdateCompanionBuilder =
    DailyQuestsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<bool> isCompleted,
      Value<int> streak,
      Value<DateTime?> lastCompletedDate,
      Value<int> rowid,
    });

class $$DailyQuestsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyQuestsTable> {
  $$DailyQuestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyQuestsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyQuestsTable> {
  $$DailyQuestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyQuestsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyQuestsTable> {
  $$DailyQuestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<DateTime> get lastCompletedDate => $composableBuilder(
    column: $table.lastCompletedDate,
    builder: (column) => column,
  );
}

class $$DailyQuestsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyQuestsTable,
          DailyQuest,
          $$DailyQuestsTableFilterComposer,
          $$DailyQuestsTableOrderingComposer,
          $$DailyQuestsTableAnnotationComposer,
          $$DailyQuestsTableCreateCompanionBuilder,
          $$DailyQuestsTableUpdateCompanionBuilder,
          (
            DailyQuest,
            BaseReferences<_$AppDatabase, $DailyQuestsTable, DailyQuest>,
          ),
          DailyQuest,
          PrefetchHooks Function()
        > {
  $$DailyQuestsTableTableManager(_$AppDatabase db, $DailyQuestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyQuestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyQuestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyQuestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<DateTime?> lastCompletedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestsCompanion(
                id: id,
                title: title,
                description: description,
                isCompleted: isCompleted,
                streak: streak,
                lastCompletedDate: lastCompletedDate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> description = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<DateTime?> lastCompletedDate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyQuestsCompanion.insert(
                id: id,
                title: title,
                description: description,
                isCompleted: isCompleted,
                streak: streak,
                lastCompletedDate: lastCompletedDate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyQuestsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyQuestsTable,
      DailyQuest,
      $$DailyQuestsTableFilterComposer,
      $$DailyQuestsTableOrderingComposer,
      $$DailyQuestsTableAnnotationComposer,
      $$DailyQuestsTableCreateCompanionBuilder,
      $$DailyQuestsTableUpdateCompanionBuilder,
      (
        DailyQuest,
        BaseReferences<_$AppDatabase, $DailyQuestsTable, DailyQuest>,
      ),
      DailyQuest,
      PrefetchHooks Function()
    >;
typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      required String id,
      required String title,
      Value<bool> isPositive,
      Value<bool> isNegative,
      Value<int> positiveCount,
      Value<int> negativeCount,
      Value<String> historyDatesJson,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<bool> isPositive,
      Value<bool> isNegative,
      Value<int> positiveCount,
      Value<int> negativeCount,
      Value<String> historyDatesJson,
      Value<int> rowid,
    });

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPositive => $composableBuilder(
    column: $table.isPositive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNegative => $composableBuilder(
    column: $table.isNegative,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positiveCount => $composableBuilder(
    column: $table.positiveCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get negativeCount => $composableBuilder(
    column: $table.negativeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get historyDatesJson => $composableBuilder(
    column: $table.historyDatesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPositive => $composableBuilder(
    column: $table.isPositive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNegative => $composableBuilder(
    column: $table.isNegative,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positiveCount => $composableBuilder(
    column: $table.positiveCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get negativeCount => $composableBuilder(
    column: $table.negativeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get historyDatesJson => $composableBuilder(
    column: $table.historyDatesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isPositive => $composableBuilder(
    column: $table.isPositive,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isNegative => $composableBuilder(
    column: $table.isNegative,
    builder: (column) => column,
  );

  GeneratedColumn<int> get positiveCount => $composableBuilder(
    column: $table.positiveCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get negativeCount => $composableBuilder(
    column: $table.negativeCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get historyDatesJson => $composableBuilder(
    column: $table.historyDatesJson,
    builder: (column) => column,
  );
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
          Habit,
          PrefetchHooks Function()
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isPositive = const Value.absent(),
                Value<bool> isNegative = const Value.absent(),
                Value<int> positiveCount = const Value.absent(),
                Value<int> negativeCount = const Value.absent(),
                Value<String> historyDatesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                title: title,
                isPositive: isPositive,
                isNegative: isNegative,
                positiveCount: positiveCount,
                negativeCount: negativeCount,
                historyDatesJson: historyDatesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<bool> isPositive = const Value.absent(),
                Value<bool> isNegative = const Value.absent(),
                Value<int> positiveCount = const Value.absent(),
                Value<int> negativeCount = const Value.absent(),
                Value<String> historyDatesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                title: title,
                isPositive: isPositive,
                isNegative: isNegative,
                positiveCount: positiveCount,
                negativeCount: negativeCount,
                historyDatesJson: historyDatesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, BaseReferences<_$AppDatabase, $HabitsTable, Habit>),
      Habit,
      PrefetchHooks Function()
    >;
typedef $$TavernItemsTableCreateCompanionBuilder =
    TavernItemsCompanion Function({
      required String id,
      required String name,
      Value<String> description,
      required String category,
      required int cost,
      Value<String> effectType,
      Value<int> effectValue,
      required String iconAsset,
      Value<bool> isPurchased,
      Value<int> quantity,
      Value<int> rowid,
    });
typedef $$TavernItemsTableUpdateCompanionBuilder =
    TavernItemsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> description,
      Value<String> category,
      Value<int> cost,
      Value<String> effectType,
      Value<int> effectValue,
      Value<String> iconAsset,
      Value<bool> isPurchased,
      Value<int> quantity,
      Value<int> rowid,
    });

class $$TavernItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TavernItemsTable> {
  $$TavernItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectType => $composableBuilder(
    column: $table.effectType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get effectValue => $composableBuilder(
    column: $table.effectValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconAsset => $composableBuilder(
    column: $table.iconAsset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TavernItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TavernItemsTable> {
  $$TavernItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectType => $composableBuilder(
    column: $table.effectType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effectValue => $composableBuilder(
    column: $table.effectValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconAsset => $composableBuilder(
    column: $table.iconAsset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TavernItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TavernItemsTable> {
  $$TavernItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<String> get effectType => $composableBuilder(
    column: $table.effectType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get effectValue => $composableBuilder(
    column: $table.effectValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconAsset =>
      $composableBuilder(column: $table.iconAsset, builder: (column) => column);

  GeneratedColumn<bool> get isPurchased => $composableBuilder(
    column: $table.isPurchased,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$TavernItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TavernItemsTable,
          TavernItem,
          $$TavernItemsTableFilterComposer,
          $$TavernItemsTableOrderingComposer,
          $$TavernItemsTableAnnotationComposer,
          $$TavernItemsTableCreateCompanionBuilder,
          $$TavernItemsTableUpdateCompanionBuilder,
          (
            TavernItem,
            BaseReferences<_$AppDatabase, $TavernItemsTable, TavernItem>,
          ),
          TavernItem,
          PrefetchHooks Function()
        > {
  $$TavernItemsTableTableManager(_$AppDatabase db, $TavernItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TavernItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TavernItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TavernItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<String> effectType = const Value.absent(),
                Value<int> effectValue = const Value.absent(),
                Value<String> iconAsset = const Value.absent(),
                Value<bool> isPurchased = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TavernItemsCompanion(
                id: id,
                name: name,
                description: description,
                category: category,
                cost: cost,
                effectType: effectType,
                effectValue: effectValue,
                iconAsset: iconAsset,
                isPurchased: isPurchased,
                quantity: quantity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> description = const Value.absent(),
                required String category,
                required int cost,
                Value<String> effectType = const Value.absent(),
                Value<int> effectValue = const Value.absent(),
                required String iconAsset,
                Value<bool> isPurchased = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TavernItemsCompanion.insert(
                id: id,
                name: name,
                description: description,
                category: category,
                cost: cost,
                effectType: effectType,
                effectValue: effectValue,
                iconAsset: iconAsset,
                isPurchased: isPurchased,
                quantity: quantity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TavernItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TavernItemsTable,
      TavernItem,
      $$TavernItemsTableFilterComposer,
      $$TavernItemsTableOrderingComposer,
      $$TavernItemsTableAnnotationComposer,
      $$TavernItemsTableCreateCompanionBuilder,
      $$TavernItemsTableUpdateCompanionBuilder,
      (
        TavernItem,
        BaseReferences<_$AppDatabase, $TavernItemsTable, TavernItem>,
      ),
      TavernItem,
      PrefetchHooks Function()
    >;
typedef $$CombatLogsTableCreateCompanionBuilder =
    CombatLogsCompanion Function({
      required String id,
      Value<DateTime> timestamp,
      required String textContent,
      Value<int> damage,
      Value<bool> isCritical,
      Value<int> rowid,
    });
typedef $$CombatLogsTableUpdateCompanionBuilder =
    CombatLogsCompanion Function({
      Value<String> id,
      Value<DateTime> timestamp,
      Value<String> textContent,
      Value<int> damage,
      Value<bool> isCritical,
      Value<int> rowid,
    });

class $$CombatLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CombatLogsTable> {
  $$CombatLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CombatLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CombatLogsTable> {
  $$CombatLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get damage => $composableBuilder(
    column: $table.damage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CombatLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CombatLogsTable> {
  $$CombatLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get textContent => $composableBuilder(
    column: $table.textContent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get damage =>
      $composableBuilder(column: $table.damage, builder: (column) => column);

  GeneratedColumn<bool> get isCritical => $composableBuilder(
    column: $table.isCritical,
    builder: (column) => column,
  );
}

class $$CombatLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CombatLogsTable,
          CombatLog,
          $$CombatLogsTableFilterComposer,
          $$CombatLogsTableOrderingComposer,
          $$CombatLogsTableAnnotationComposer,
          $$CombatLogsTableCreateCompanionBuilder,
          $$CombatLogsTableUpdateCompanionBuilder,
          (
            CombatLog,
            BaseReferences<_$AppDatabase, $CombatLogsTable, CombatLog>,
          ),
          CombatLog,
          PrefetchHooks Function()
        > {
  $$CombatLogsTableTableManager(_$AppDatabase db, $CombatLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CombatLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CombatLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CombatLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> textContent = const Value.absent(),
                Value<int> damage = const Value.absent(),
                Value<bool> isCritical = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CombatLogsCompanion(
                id: id,
                timestamp: timestamp,
                textContent: textContent,
                damage: damage,
                isCritical: isCritical,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> timestamp = const Value.absent(),
                required String textContent,
                Value<int> damage = const Value.absent(),
                Value<bool> isCritical = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CombatLogsCompanion.insert(
                id: id,
                timestamp: timestamp,
                textContent: textContent,
                damage: damage,
                isCritical: isCritical,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CombatLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CombatLogsTable,
      CombatLog,
      $$CombatLogsTableFilterComposer,
      $$CombatLogsTableOrderingComposer,
      $$CombatLogsTableAnnotationComposer,
      $$CombatLogsTableCreateCompanionBuilder,
      $$CombatLogsTableUpdateCompanionBuilder,
      (CombatLog, BaseReferences<_$AppDatabase, $CombatLogsTable, CombatLog>),
      CombatLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HeroesTableTableManager get heroes =>
      $$HeroesTableTableManager(_db, _db.heroes);
  $$BossesTableTableManager get bosses =>
      $$BossesTableTableManager(_db, _db.bosses);
  $$QuestsTableTableManager get quests =>
      $$QuestsTableTableManager(_db, _db.quests);
  $$DailyQuestsTableTableManager get dailyQuests =>
      $$DailyQuestsTableTableManager(_db, _db.dailyQuests);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$TavernItemsTableTableManager get tavernItems =>
      $$TavernItemsTableTableManager(_db, _db.tavernItems);
  $$CombatLogsTableTableManager get combatLogs =>
      $$CombatLogsTableTableManager(_db, _db.combatLogs);
}

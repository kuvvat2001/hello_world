// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Booklesson {
    final List<Date> date;

    Booklesson({
        required this.date,
    });

    Booklesson copyWith({
        List<Date>? date,
    }) => 
        Booklesson(
            date: date ?? this.date,
        );

    factory Booklesson.fromRawJson(String str) => Booklesson.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Booklesson.fromJson(Map<String, dynamic> json) => Booklesson(
        date: List<Date>.from(json["date"].map((x) => Date.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "date": List<dynamic>.from(date.map((x) => x.toJson())),
    };
}

class Date {
    final Tesk tesk;

    Date({
        required this.tesk,
    });

    Date copyWith({
        Tesk? tesk,
    }) => 
        Date(
            tesk: tesk ?? this.tesk,
        );

    factory Date.fromRawJson(String str) => Date.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Date.fromJson(Map<String, dynamic> json) => Date(
        tesk: Tesk.fromJson(json["tesk"]),
    );

    Map<String, dynamic> toJson() => {
        "tesk": tesk.toJson(),
    };
}

class Tesk {
    final String titil;
    final String books;

    Tesk({
        required this.titil,
        required this.books,
    });

    Tesk copyWith({
        String? titil,
        String? books,
    }) => 
        Tesk(
            titil: titil ?? this.titil,
            books: books ?? this.books,
        );

    factory Tesk.fromRawJson(String str) => Tesk.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Tesk.fromJson(Map<String, dynamic> json) => Tesk(
        titil: json["titil"],
        books: json["books"],
    );

    Map<String, dynamic> toJson() => {
        "titil": titil,
        "books": books,
    };
}

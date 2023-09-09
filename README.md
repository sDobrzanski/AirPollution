## 1. Architektura i opis systemu
Jako projekt stworzona została aplikacja webowa umożliwiająca dostęp do danych
dotyczących stanu powietrza. Aplikacja działa w pełni w chmurze. Architektura całego systemu
składa się z następujących komponentów:
- SILAM jest modelem dyspersji w skali globalnej, opracowanym do zastosowań związanych
ze składem atmosfery, jakością powietrza, wspomaganiem decyzji w sytuacjach kryzysowych, jak
również do rozwiązywania problemów dyspersji odwrotnej
- Open Weather Air Pollution API zapewnia aktualne, prognozowane i historyczne dane o
zanieczyszczeniu powietrza dla dowolnych współrzędnych na kuli ziemskiej
- Google Maps API zapewnia dostęp do map z całego świata
- Aplikacja Webowa została napisana we Flutterze
- Usługi chmurowe AWS i Firebase (opisane poniżej)
- Terraform (opisane poniżej)
  
<img width="1313" alt="Architektura system" src="https://github.com/sDobrzanski/AirPollution/assets/44682121/1fa69102-8653-4375-b124-cca34f254117">
<sub>Rys. 1 Architektura systemu</sub>

Aplikacja webowa została napisana we Flutterze. Jako źródło danych użyto Open Weather Air
Pollution API, który udostępnia dane powietrza w każdym punkcie na ziemi. Poniżej przedstawiono
implementację komunikacji z API.
```
Future<AirPollutionData>? getCurrentAirData(String lat, String long)
async {
final Map<String, dynamic> query = <String, dynamic>{};
query.addAll({
'appid': _apiKey,
'lat': lat,
'lon': long,
});
Uri uri = Uri.https(_recipesUrl, '/data/2.5/air_pollution', query);

final dynamic result =
await _cloudFunctionsService.httpRequestViaServer(uri);
final AirPollutionData airData = AirPollutionData.fromJson(result);
return airData;
}
```

Do zapytania należy przekazać długość i szerokość geograficzną punktu z, którego chcemy
uzyskać dane. W przypadku danych historycznych dodatkowo należy przekazać ramy czasowe od –
do.
Aby uzyskać współrzędne geograficzne miejsca wybranego przez użytkownika użyte zostało
Google Maps API. Request potrzebuje nazwy miejsca jak np. Kraków bądź dokładniejszego adresu
np. Kraków, ul. Czaronowiejska 15. Z funkcji zwrócone zostaną parametry danego miejsca w tym
jego długość i szerokość geograficzna, które następnie zostaną przekazane do requestu Air Pollution
API opisanego wyżej.

```
Future<GeolocationData> getLocationLatLong(String place) async {
String url = "maps.googleapis.com";
final Map<String, dynamic> query = <String, dynamic>{};
query.addAll({
'address': place,
'key': _apiKey,
});
Uri uri = Uri.https(url, '/maps/api/geocode/json', query);
final dynamic result =
await _cloudFunctionsService.httpRequestViaServer(uri);
final GeolocationData geolocationData =
GeolocationData.fromJson(result);
return geolocationData;
}
```

Okazało się, że przy próbie wywoływania requestów zwracany jest błąd XMLHttpRequest.
Jest on spowodowany tym, że niektóre API uniemożliwiają wykonywanie requestów po stronie klienta
ze względu na CORS. Jednym z rozwiązań tego problemu jest wysyłanie żądania do proxy. Serwer
cors-anywhere jest serwerem proxy, który dodaje nagłówki CORS do żądania. Proxy działa jako
pośrednik pomiędzy klientem a serwerem, dzięki czemu można kontrolować adres backendu, do
którego trafiają żądania API aplikacji internetowej. Niestety jest to niepewne rozwiązanie ze względu
na niestabilność oraz zabezpieczenia publicznych serwerów proxy. Ze względu na to zdecydowano na
obejście problemu CORS wysyłając zapytanie od strony serwera. Wykorzystana została do tego
funkcjonalność Firebase Functions udostępniana przez Google Firebase.
Cloud Functions dla Firebase to bezserwerowy framework, który pozwala na automatyczne
uruchamianie kodu backendu w odpowiedzi na zdarzenia wywołane przez funkcje Firebase i żądania
HTTPS. Kod JavaScript lub TypeScript jest przechowywany w chmurze Google i działa w
zarządzanym środowisku. Nie ma potrzeby zarządzania i skalowania własnych serwerów.
Funkcja napisana została w języku TypeScript. Po wywołaniu odbiera ona adres URL
stworzony po stronie Frontendu, następnie wywołuje go i zwróconą zawartość zwraca do klienta.

```
exports.getDataFromUrl = functions.https.onCall(async (data, context) =>
{
const url = data.url;
try {

const info = await axios.get(url);
return info.data;
} catch (error) {
return (error);
}
});
```

Poniżej przedstawiono implementację funkcji do wywołania funkcji chmurowej.
Funkcjonalność komunikacji z Firebase jest zapewniana przez biblioteki Firebase dla Fluttera.
Funkcja ta jest następnie używana w metodach zwracających dane z Air Pollution API i Google Places
API opisanych wyżej.

```
Future<dynamic> httpRequestViaServer(Uri uri) async {
HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
'getDataFromUrl',
);
try {
final HttpsCallableResult result = await callable.call(
<String, dynamic>{
'url': uri.toString(),
},
);
return result.data;
} on FirebaseFunctionsException catch (e) {
throw 'Caught firebase functions exception ${e.code} ${e.message}
${e.details}';
} catch (e) {
throw 'Caught generic exception $e';
}
}

```
W konsoli Firebase można śledzić aktywność funkcji.

<img width="1224" alt="Konsola Firebase Functions" src="https://github.com/sDobrzanski/AirPollution/assets/44682121/065e3ccc-e0b1-4f1a-b0be-eb27d44a334a">
<sub>Rys.2 Konsola Firebase Functions</sub>

<img width="1257" alt="Ilość wywołań funkcji w czasie" src="https://github.com/sDobrzanski/AirPollution/assets/44682121/519f9dc9-c1c6-437b-96ac-508e4fea0faa">
<sub>Rys. 3 Ilość wywołań funkcji w czasie</sub>

## 2. Wdrożenie aplikacji na AWS
Celem projektu było wdrożenie aplikacji na usługach zapewnianych przez AWS. Poniżej
przedstawiono schemat sieci z serwisami użytymi do w pełni zabezpieczonego zhostowania aplikacji
w AWS.

<img width="1254" alt="Zasoby AWS dla strony" src="https://github.com/sDobrzanski/AirPollution/assets/44682121/3145268c-442a-48c7-8821-8b2765e73f17">
<sub>Rys. 4 Zasoby AWS dla strony</sub>

- Wszystkie pliki statyczne będą znajdowały się w buckecie S3.
- Cloudfront będzie działał jako CDN i udostępniał zawartość bucketu S3 używając HTTPS.
- Certificate Manager dostarcza certyfikaty SSL do Cloudfront i zarządza nimi (odnawia je po
wygaśnięciu).
- Route53 zarządza wszystkimi naszymi rekordami DNS i ustawia rekord A tak, aby wskazywał
na dystrybucję Cloudfront.
- Rejestratorzy domen skierują nazwy domen do AWS Nameservers.
  
W celu stworzenia infrastruktury chmurowej napisany został skrypt Terraform.
Terraform jest oprogramowaniem typu open-source Infrastructure as Code stworzonym przez
HashiCorp. Użytkownicy definiują i udostępniają infrastrukturę za pomocą deklaratywnego języka
konfiguracji znanego jako HashiCorp Configuration Language lub opcjonalnie JSON.
Pierwszy komponent to bucket S3 bucket, który zawiera nasz statyczny kod i zasoby.
Dodajemy dla niego 2 właściwości: użycie bloku website {}, który umożliwia statyczny hosting oraz
politykę bucketu jako każdy może uzyskać dostęp (GETObject) do zawartości pliku, ale nie może jej
modyfikować (UPDATE | DELETE).

```
//AWS Providers
provider "aws" {
access_key = var.aws_access_key
secret_key = var.aws_secret_key
region = var.region
}
provider "aws" {

alias = "acm_provider"
region = "us-east-1"
}
resource "aws_s3_bucket" "main" {
bucket = var.bucket_name
acl = "private"
policy = data.aws_iam_policy_document.bucket_policy.json
website {
index_document = "index.html"
}
tags = {
"Name" = var.bucket_name
}
}
data "aws_iam_policy_document" "bucket_policy" {
statement {
sid = "AllowReadFromAll"
actions = [
"s3:GetObject",
]
resources = [
"arn:aws:s3:::${var.bucket_name}/*",
]
principals {
type = "*"
identifiers = ["*"]
}
}
}

```
Możemy teraz uzyskać dostęp do zawartości bucketu S3. W takim przypadku content będzie
serwowany jako HTTP, a nie jako HTTPS, nie ma polityki cache oraz customowych headerów (brak
funkcjonalności CDN). Dlatego zostaje dodany kolejny komponent w postaci dystrybucji Cloudfront.

```
resource "aws_cloudfront_distribution" "main" {
origin {
domain_name = aws_s3_bucket.main.website_endpoint
origin_id = "S3-www.${var.bucket_name}"
custom_origin_config {
http_port = 80
https_port = 443

origin_protocol_policy = "http-only"
origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
}
}
enabled = true
is_ipv6_enabled = true
default_root_object = "index.html"
default_cache_behavior {
.
.
.
}
```

Określamy w nim wcześniej stworzony bucket S3. Przekierowujemy wszystkie zapytania
HTTP na HTTPS oraz w przypadku certyfikatów SSL odnosimy się do
aws_acm_certificate_validation resource.
Aby obsłużyć ruch HTTPS potrzebujemy certyfikatów SSL. Będą one wydawane i zarządzane
przez Certificate Manager.

```
resource "aws_acm_certificate" "cert" {
domain_name = var.domain_name
validation_method = "DNS"
provider = aws.acm_provider
}
resource "aws_acm_certificate_validation" "cert" {
certificate_arn = aws_acm_certificate.cert.arn
validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
provider = aws.acm_provider
}
resource "aws_route53_record" "cert_validation" {
name =
tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_r
ecord_name
type =
tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_r
ecord_type
records =
[tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_
record_value]
zone_id = aws_route53_zone.main.id
ttl = 60
}
```

Istnieją 2 metody walidacji, tego że domena należy do nas. W tym przypadku użyta zostanie
walidacja DNS (druga to walidacja poprzez email). Domena została zakupiona u rejestratora domen
home.pl.

<img width="1260" alt="Domena w home.pl" src="https://github.com/sDobrzanski/AirPollution/assets/44682121/74900277-ffe3-4bbd-a73d-84bc0ae35c16">
<sub>Rys.5 Domena w home.pl</sub>

<img width="726" alt="Nazwy serwerów AWS" src="https://github.com/sDobrzanski/AirPollution/assets/44682121/8b41921b-d47b-454f-b5f4-8271486932a8">
<sub>Rys.6 Nazwy serwerów AWS</sub>

Ze względu na to, że aplikacja jest hostowana w AWS na stronie gdzie zarejestrowano
domenę należało dodać nazwy serwerów AWS przez które przechodzić będzie hosting DNS.
Ostatni komponent do dodania to Route53. Tworzymy strefę hostowaną, która jest plikiem
strefy DNS i może zarządzać wszystkimi subdomenami w jej obrębie jako rekordy DNS. Następnie
tworzymy Rekord DNS w strefie Hosted i wskazujemy go na dystrybucję CloudFront, którą
stworzyliśmy wcześniej.

```
resource "aws_route53_zone" "main" {
name = var.domain_name
}
resource "aws_route53_record" "app" {
zone_id = aws_route53_zone.main.zone_id
name = var.bucket_name
type = "A"
alias {
name =
aws_cloudfront_distribution.main.domain_name
zone_id =
aws_cloudfront_distribution.main.hosted_zone_id

evaluate_target_health = false
}
}
Na sam koniec również za pomocą skryptu Terraform do bucketu S3 zostają dodane pliki
tworzące aplikację webową.

resource "null_resource" "remove_and_upload_to_www_s3" {
provisioner "local-exec" {
command = "aws s3 sync
C:/Users/szdob/StudioProjects/air_pollution_app/build/web
s3://${aws_s3_bucket.main.id}"
}
}
```

Skrypt zostaje uruchomiony za pomocą komendy terraform apply.

## 3. Działanie aplikacji
Aplikacja dostępna jest (była* hosting nie jest już opłacany) pod adresem: https://cloudairpollutionagh.pl/
Na stronie głównej widoczna jest mapa, na której po wpisaniu miejsca postawiona zostanie
pinezka zawierające dane z aktualnym stanem powietrza. Parametry przedstawione są to parametry
AQI czyli indeksu stanu powietrza:
- ozon w warstwie przyziemnej
- zanieczyszczenie cząstkami stałymi (znanymi również jako pył zawieszony, w tym PM2.5 i PM10)
- tlenek węgla
- dwutlenek siarki
- dwutlenek azotu

<img width="1269" alt="Strona główna aplikacji" src="https://github.com/sDobrzanski/AirPollution/assets/44682121/929b3b3c-0b19-4513-93c0-967db9ea3f0a">
<sub>Rys. 7 Strona główna aplikacji</sub>

Na drugiej stronie użytkownik jest w stanie sprawdzić historyczne dane stanu powietrza.
Zostaną one wyświetlone w formie wykresów wartości wskaźnika w czasie.

<img width="1233" alt="Strona z danymi historycznym" src="https://github.com/sDobrzanski/AirPollution/assets/44682121/54c40069-9f20-45b4-9c35-f99fd40e0590">
<sub>Rys. 8 Strona z danymi historycznym</sub>

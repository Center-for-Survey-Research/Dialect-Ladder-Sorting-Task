<cfsetting showdebugoutput="no"><cfoutput><!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"><!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <meta name="google" content="notranslate" />        
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>#request.title#</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@200;400;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="#request.url#/css/jquery-ui.min.css">
        <link rel="stylesheet" href="#request.url#/css/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="#request.url#/css/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="#request.url#/css/style.css?v=#datediff("s","2021-08-04 00:00:00",now())#">
	</head>
    <body<cfif request.id neq ""> data-id="#request.id#"</cfif><cfif request.page neq ""> data-page="#request.page#"</cfif>></cfoutput>
	
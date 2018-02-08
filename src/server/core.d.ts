interface Submission {
    code?: string,
    language?: string,
    problem?: string | object,
    user?: string,
    round?: string | object,
    summary: object,
    results: [object]
}

declare async function judge(lang: string, code: string, config: object, doc: Submission): object

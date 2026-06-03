export class Reporter {
  passes = 0;
  warnings = 0;
  failures = 0;

  pass(message: string): void {
    this.passes += 1;
    console.log(`[PASS] ${message}`);
  }

  warn(message: string): void {
    this.warnings += 1;
    console.log(`[WARN] ${message}`);
  }

  fail(message: string): void {
    this.failures += 1;
    console.log(`[FAIL] ${message}`);
  }

  summary(): void {
    console.log();
    console.log(`Summary: ${this.passes} passed, ${this.warnings} warning(s), ${this.failures} failure(s)`);
  }

  exitCode(): number {
    return this.failures > 0 ? 1 : 0;
  }
}
